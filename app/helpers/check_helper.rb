require 'timeout'

module CheckHelper
  include ApplicationHelper


  def check_host_sqs(ip)
    url = "https://sqs.ap-northeast-1.amazonaws.com/750753468831/qrv"
    sqs = AWS::SQS.new(:sqs_endpoint => 'sqs.ap-northeast-1.amazonaws.com')
    queue = sqs.queues[url]

    if ip && ip_format_check(ip)
      msg = queue.send_message ip
    end
  end

  def check_host(ip)
    s0 = ''

    if ip && ip_format_check(ip)

      headers = {
        'Host'=>'cdn.debian.net',
        'User-Agent' => 'Debian-cdn-cname-ping/1.0'
      }
      begin
        h = Net::HTTP.new(ip)
        h.open_timeout = 8 
        h.read_timeout = 8
        s0 = h.get("/debian/project/trace/ftp-master.debian.org", headers)
      rescue Timeout::Error
        return false, 'timeout: ' + ip , $!
      rescue Errno::ECONNREFUSED
        return false, 'refused: ' + ip , $!
      rescue
        return false, "fail", $!
      end

      if s0.code.to_i == 200
        return true, s0.body, s0.header['last-modified']
      else
        return false, s0.body, s0.code
      end
    else
      return false, "fail", s0.code
    end
  end
end
