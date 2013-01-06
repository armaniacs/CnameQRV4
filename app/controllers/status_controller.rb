class StatusController < ApplicationController

  # GET /status/all
  def all
    @hosts = Host.all.entries
    respond_to do |format|
      format.html { render :text => @hosts.to_json }
    end
  end
  # GET /status/alive
  def alive
    @hosts = Host.where(:alive => 1).entries
    @hosts_jp = Host.where("alive = '1' AND hostname = 'jp.cdn.araki.net'").entries
    if @hosts_jp.size == 0
      @hosts_jp = Host.where(:hostname => 'jp.cdn.araki.net').order(:preference).entries

      @hosts += @hosts_jp
    end

    respond_to do |format|
      format.html { render :text => @hosts.to_json }
    end
  end

end
