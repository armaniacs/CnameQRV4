class HostsController < ApplicationController
  # GET /hosts
  # GET /hosts.xml
  def index
    @hosts = Host.all.order(:country)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @hosts }
    end
  end

  # GET /hosts/1
  # GET /hosts/1.xml
  def show
    # @host = Host.find(params[:id])
    begin
      @host = Host.find(params[:_id])
    rescue
      render :text => "Please retry. Wait a minute."
    else
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @host }
      end
    end
  end

  # GET /hosts/new
  # GET /hosts/new.xml
  def new
    @host = Host.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @host }
    end
  end

  # GET /hosts/1/edit
  def edit
    @host = Host.find(params[:_id])
  end

  # POST /hosts
  # POST /hosts.xml
  def create
    @host = Host.new(params[:host])

    respond_to do |format|
      if @host.save
        format.html { redirect_to(@host, :notice => 'Host was successfully created.') }
        format.xml  { render :xml => @host, :status => :created, :location => @host }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @host.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /hosts/1
  # PUT /hosts/1.xml
  def update
    @host = Host.find(params[:id])

    respond_to do |format|
      if @host.update_attributes(params[:host])
        format.html { redirect_to(@host, :notice => 'Host was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @host.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /hosts/1
  # DELETE /hosts/1.xml
  def destroy
    begin
      @host = Host.find(params[:_id])
      @host.delete
    rescue
    end

    respond_to do |format|
      sleep 2
      format.html { redirect_to(hosts_url) }
      format.xml  { head :ok }
    end
  end

  def picks
    params[:pick].each do |k,v|
      if v == "true"
        @host = Host.find(k)
        @host.delete        
      end
    end
    respond_to do |format|
      sleep 2
      format.html { redirect_to(hosts_url) }
      format.xml  { head :ok }
    end
    
  end
end
