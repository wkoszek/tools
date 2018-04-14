#!/usr/bin/env ruby

require 'yaml'
require 'net/ftp'
require 'pp'

def main
  debug_mode = false
  ARGV.each do |a|
    if a =~ /^-d/
      debug_mode = true
    end
  end

  cfg_raw = File.read(File.join(ENV["HOME"], ".mptm.cfg"))
  cfg = YAML.load(cfg_raw)

  puts "starting"
  ftp = Net::FTP.new
  ftp.passive = true
  ftp.debug_mode = debug_mode
  ftp.connect(cfg["host"])
  ftp.login(cfg["user"], cfg["pass"])

  ftp.chdir(cfg["dir"])

  f_excl = [ ] # "sync.rb" ]
  f_incl = Dir['*']
  f_sync = f_incl - f_excl

  f_sync.each do |f|
    ftp.putbinaryfile(f, "/public_html/#{f}")
  end
end

main
