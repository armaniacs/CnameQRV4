class CheckController < ApplicationController
  include ApplicationHelper
  include CheckHelper

  def ip
    ch_tf, ch_body = check_host(params['ip'])
    if ch_tf
      render :text => ch_body
    else
      render :text => "fail", :status => 404
    end
  end

  def all
    i = 0
    hosts = Host.find(:all)
    hosts.each do |h|
      h.uptodate
      i +=1
    end
    render :text => i.to_s + ' host(s) are checked'
  end

  def check20 # Usually, use this
    hosts = Host.order(:time)
    i = 0
    ir = rand(100)
    hosts.each do |h|
      logger.debug(h.ip)
      h.period_check
      i += 1

      if i > ir
        break
      end
    end

    render :text => i.to_s + ' host(s) are checked'
  end

  def check20_strict # Usually, use this
    hosts = Host.order(:time)
    i = 0
    ir = rand(100)
    hosts.each do |h|
      logger.debug(h.ip)
      logger.debug(h.alive)
      if h.alive == 1
        h.period_check
        i += 1
      else
        h.time = Time.now
        h.save
      end

      if i > ir
        break
      end

    end
    render :text => i.to_s + ' host(s) are checked'
  end

  def country
    i = 0
    pc = params['country']
    if country_format_check(pc)
      hosts = Host.where('country = ?', pc)
      hosts.each do |h|
        h.uptodate
        i += 1
      end
      render :text => '[' + pc + '] country ' + i.to_s + ' host(s) done'
    else
      render :text => 'invalid format'
    end
  end

  def continent
    hosts = Host.where('continent = ?', params['continent'])
    hosts.each do |h|
      h.uptodate
    end
    render :text => 'check continent done'
  end

end
