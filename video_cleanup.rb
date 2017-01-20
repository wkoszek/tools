#!/usr/bin/env ruby
# Copyright (c) 2017 Wojciech Adam Koszek <wojciech@koszek.com>

# video file organizer. pass the filenames and it'll grab only
# files from the camera (.mov/.MOV) and rename them with a data prefix.

require 'streamio-ffmpeg'
require 'pp'

class SmartFile
	attr_writer :fn, :movie

	@@supported_formats = ["video/quicktime", "video/mp4"]

	def initialize(filename)
		@fn = filename
		@movie = nil
		if @@supported_formats.include?(mime_type()) then
			@movie = FFMPEG::Movie.new(@fn)
		end
	end

	def mime_type
		mimetype = `file -Ib "#{@fn}"`.gsub(/\n/,"")
		if mimetype =~ /;/ then
			mimetype = mimetype.split(";")[0]
		end
		return mimetype
	end

	def filename_orig
		return @fn
	end

	def filename_new
		if @movie == nil then
			return @fn
		end
		ct = @movie.creation_time
		if ct == nil then
			print "ct == nil!!!"
			return @fn
		end
		new_fn = "%04d%02d%02d-%s" % [ct.year, ct.month, ct.day, @fn]
		new_fn.gsub!(/\s+/, "_")
		new_fn.gsub!(/-/, "_")
		return new_fn
	end

	def need_move?
		if filename_orig != filename_new
			return true
		end
		return false
	end
end

m_all = []
ARGV.each do |arg|
	m_all << SmartFile.new(arg)
end

m_all.each do |m|
	print "# testing #{m.filename_orig} #{m.mime_type}\n"
	if m.need_move? then
		print "mv \"#{m.filename_orig}\" \"#{m.filename_new}\"\n"
	end
end

#movie = FFMPEG::Movie.new(ARGV[2])
#pp movie.creation_time.year
#pp movie # 7.5 (duration of the movie in seconds)
#movie.bitrate # 481 (bitrate in kb/s)
#movie.size # 455546 (filesize in bytes)
#
#movie.video_stream # "h264, yuv420p, 640x480 [PAR 1:1 DAR 4:3], 371 kb/s, 16.75 fps, 15 tbr, 600 tbn, 1200 tbc" (raw video stream info)
#movie.video_codec # "h264"
#movie.colorspace # "yuv420p"
#movie.resolution # "640x480"
#movie.width # 640 (width of the movie in pixels)
#movie.height # 480 (height of the movie in pixels)
#movie.frame_rate # 16.72 (frames per second)
#
#movie.audio_stream # "aac, 44100 Hz, stereo, s16, 75 kb/s" (raw audio stream info)
#movie.audio_codec # "aac"
#movie.audio_sample_rate # 44100
#movie.audio_channels # 2
#
## Multiple audio streams
#movie.audio_streams[0] # "aac, 44100 Hz, stereo, s16, 75 kb/s" (raw audio stream info)
#
#movie.valid? # true (would be false if ffmpeg fails to read the movie)
