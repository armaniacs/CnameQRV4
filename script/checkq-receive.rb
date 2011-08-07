###
# check and process for hosts
###

require 'rubygems'
require "aws"
require 'date'
require 'syslog'

config_file = File.join(File.dirname(__FILE__),"../config/","aws.yml")
unless File.exist?(config_file)
  exit 1
end

config = YAML.load(File.read(config_file))
AWS.config(config["development"])

slog = Syslog.open(__FILE__,   
                  Syslog::Constants::LOG_PID |
                  Syslog::Constants::LOG_CONS,
                  Syslog::Constants::LOG_DAEMON)
slog.info "start checkq-receive"
if Process.respond_to? :daemon  # Ruby 1.9
  Process.daemon
else                            # Ruby 1.8
  require 'webrick'
  WEBrick::Daemon.start
end


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

def ip_format_check(ip_str)
  if ip_str =~ /\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b/
    return true
  elsif ip_str == ""
    return true
  else
    return false
  end
end


def check_host(ip)
  s0 = ''
  headers = {
    'Host'=>'cdn.debian.net',
    'User-Agent' => 'Debian-cdn-cname-ping/1.2'
  }
  mirrors = Host.where('ip = ?', ip)
  mirrors.each do |mirror|
    begin
      h = Net::HTTP.new(ip)
      h.open_timeout = 8 
      h.read_timeout = 8
      s0 = h.get("/debian/project/trace/ftp-master.debian.org", headers)
    rescue Timeout::Error
      mirror.alive = 0
      mirror.checkpref += 1
      mirror.failreason = $!
    rescue Errno::ECONNREFUSED
      mirror.alive = 0
      mirror.checkpref += 1
      mirror.failreason = $!
    rescue
      mirror.alive = 0
      mirror.checkpref += 1
      mirror.failreason = $!
    end

    begin
      if s0.code.to_i == 200
        mirror.lastmodifiedtime = s0.header['last-modified']
        if DateTime.now - mirror.lastmodifiedtime > 86400 * 2 # DELAY
          mirror.checkpref += 1
          mirror.failreason = "DELAY"
        else
          mirror.alive = 1
          mirror.checkpref = 0
          mirror.failreason = ""
        end
      else
        mirror.alive = 0
        mirror.checkpref += 1
        mirror.failreason = ""
      end
    rescue
      mirror.alive = 0
      mirror.checkpref += 1
      mirror.failreason = ""
    end
    mirror.time = Time.now
    mirror.save
  end
end



url = "https://sqs.ap-northeast-1.amazonaws.com/750753468831/qrv"
sqs = AWS::SQS.new
queue = sqs.queues[url]

queue.poll do |msg|
  slog.info "Got message: #{msg.body}"
  if msg.body && ip_format_check(msg.body)
    check_host msg.body
  end
end




