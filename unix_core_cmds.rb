#!/usr/bin/env ruby

g_dirs = [ "/sbin", "/bin", "/usr/sbin", "/usr/bin" ]
g_cmds = {}

g_dirs.each do |dir|
	d = Dir.open(dir)
	d.each do |file|
		#print "#{file}"
		g_cmds["#{dir}/#{file}"] = dir + file
	end
	d.close()
end

g_cmds.keys.sort.each do |cmd|
	print "#{cmd}\n"
end
