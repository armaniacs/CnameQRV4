class StatusController < ApplicationController

  # GET /status/all
  def all
    @hosts = Host.all_cached
    respond_to do |format|
      format.html { render :text => @hosts.to_json }
    end
  end

  # GET /status/alive
  def alive
    @hosts = Host.alive_cached
    @hosts_jp = Host.jp_alive_cached
    if @hosts_jp.size == 0
      @hosts_jp = Host.jp_all_cached
      @hosts += @hosts_jp
    end

    respond_to do |format|
      format.html { render :text => @hosts.to_json }
    end
  end

end
