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
    respond_to do |format|
      format.html { render :text => @hosts.to_json }
    end
  end


end
