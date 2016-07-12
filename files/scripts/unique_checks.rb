#!/usr/bin/env ruby

require 'fileutils'
require 'digest/md5'

debug=false
dir=ARGV[0]
dest=ARGV[1]
files={}

Dir.foreach(dir) do |file|
  next if file == '.' or file == '..'
  md5 = Digest::MD5.hexdigest(File.read("#{dir}/#{file}"))
  files[md5] = file if !files.has_key?(md5)
end

#we remove all existing checks
#this is somewhat crude, but works.
FileUtils.rm Dir.glob("#{dest}/*__*.cfg")

files.each_pair do |md5,file|
  file_dest = file.gsub(/^(.*)__.*\.cfg$/, '\1')
  file_dest = "#{file_dest}__#{md5}.cfg"
  puts "#{md5} #{file} => #{dest}/#{file_dest}" if debug

  FileUtils.cp("#{dir}/#{file}", "#{dest}/#{file_dest}")

end
