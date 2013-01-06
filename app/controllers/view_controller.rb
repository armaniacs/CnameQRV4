class ViewController < ApplicationController
  # GET /hosts
  # GET /hosts.xml
  def index
    @hosts = Host.all
    @alives = Host.where(:alive => 1)
    @hosts_jp = Host.where("alive = '1' AND hostname = 'jp.cdn.araki.net'")

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
