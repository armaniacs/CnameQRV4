###
# This script is used for import JSON data to SimpleDB.
###

require 'rubygems'
require "aws"
require "json"

config_file = File.join(File.dirname(__FILE__),"../config/","aws.yml")
unless File.exist?(config_file)
  exit 1
end

config = YAML.load(File.read(config_file))
AWS.config(config["development"])

class Host < AWS::Record::Base
  string_attr :ip
  string_attr :hostname
  string_attr :type
  integer_attr :preference
  datetime_attr :time
  integer_attr :alive
  string_attr :country
  string_attr :continent
  integer_attr :checkpref, :default_value => 0
  string_attr :tracefile
  datetime_attr :lastmodifiedtime
  integer_attr :nouse
  string_attr :failreason
  string_attr :targetnet
  integer_attr :targetasnum
end

Host.all.each do |h0| 
  h0.delete
  h0.save
end

f = ARGV[0]
json = File.open(f, 'r').read
pj = JSON.parse(json)

pj.each do |h|
  s = Host.new
  h.each do |k,v|
    if k == "continent"
      s.continent = v
    elsif k == "country"
      s.country = v
    elsif k == "tracefile"
      s.tracefile = v
    elsif k == "checkpref"
      s.checkpref = v.to_i
    elsif k == "alive"
      if v == "True"
        s.alive = 1
      else
        s.alive = 0
      end
    elsif k == "targetasn"
      s.targetasn = v.to_i
    elsif k == "targetnet"
      s.targetnet = v
    elsif k == "type"
      s.type = v
    elsif k == "ip"
      s.ip = v
    elsif k == "hostname"
      s.hostname = v
    elsif k == "preference"
      s.preference = v.to_i
    else
    end
  end
  s.save
  p s
end

p Host.all.count
