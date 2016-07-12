#!/usr/bin/env ruby

require 'fileutils'

debug=false
dir=ARGV[0]
dest=ARGV[1]

#Each file is named like the hostgroup,
#Each line in the file is one hostgroup_member
def get_existing_members(file,dir)
  ret = []
  if File.exists?("#{dir}/#{file}")
    File.read("#{dir}/#{file}").each_line { |line|
      line.strip!
      if (mem = line.match(/^members (.*)$/))
        ret = mem[1].strip.split(',')
      end
    }
  end
  return ret
end

def get_new_members(file)
  return File.exists?(file) ? File.read(file).split(/\n/) : []
end

## MAIN
Dir.glob("#{dir}/group_*") do |item|
  next if item == '.' or item == '..'
  file=File.basename(item)
  # check whether a cfg with this already exists
  grpnam = file.gsub(/group_(.*).cfg$/, '\1')
  curr_mems = get_existing_members(file,dir)
  next_mems = get_new_members("#{dir}/#{grpnam}")
  # puts "#{grpnam} :: #{curr_mems.class} :: #{next_mems.class}"
  mems = curr_mems.concat(next_mems).flatten.compact.uniq.join(', ')
  destf = "#{dest}/#{file}"
  alas = File.open("#{dir}/#{file}").grep(/alias.*$/i)[0]
  hgroup_names = File.open("#{dir}/#{file}").grep(/hostgroup_names.*$/i)[0]
  fn = File.open(destf,'w')
  fn.write("### PUPPET ###\n")
  fn.write("define hostgroup {\n")
  fn.write("       hostgroup_name #{grpnam}\n")
  fn.write("       #{alas}") if ! alas.nil?
  fn.write("       #{hgroup_names}") if ! hgroup_names.nil?
  fn.write("       members #{mems}\n") if (!mems.nil?) and (mems.size > 0)
  fn.write("}")
  fn.close()
end
