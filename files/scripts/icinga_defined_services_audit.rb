#!/usr/bin/env ruby

#go through icinga logs and check whether all services are properly defined
# written by u.waechter@mysportgroup.de in 2013

logfile="/var/log/icinga/icinga.log"

#this results in lines like:
# 'NFS usage' on host 'backe.net.mysportgroup.de'

def print_hash(h)
  h.each_pair do |key,value|
    puts "\t #{key}"
    value.each do |v|
      puts "\t\t #{v}"
    end
  end
end

lines=%x{grep 'but the service could not be found' #{logfile} |cut -f2- -d ' ' |sed -e 's@^Warning:  Passive check result was received for service @@g' |sort |uniq |sed -e 's@, but the service could not be found!@@g'}.chomp

results = {}
results_host = {}

lines.each_line do |line|
  arr=line.gsub(/'/,'').split(/\ on\ host\ /)
  if results[arr[0]].nil?
    results[arr[0]] = []
  end
  results[arr[0]] << arr[1]
  if results_host[arr[1]].nil?
    results_host[arr[1]] = []
  end
  results_host[arr[1]] << arr[0]
end

puts "\n-> Services unknown, by service\n" if results.size > 0
print_hash(results)
puts "\n\n-> Services unknown, by host\n" if results_host.size > 0
print_hash(results_host)