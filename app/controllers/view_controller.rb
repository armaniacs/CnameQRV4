class ViewController < ApplicationController
  # GET /hosts
  # GET /hosts.xml
  def index
    @hosts = Host.all_cached
    @alives = Host.alive_cached
    @hosts_jp = Host.jp_alive_cached

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /hosts/1
  # GET /hosts/1.xml
  def show
    # @host = Host.find(params[:id])
    @host = Host.find(params[:_id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end
end
