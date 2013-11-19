class ServersController < ApplicationController


  # GET /servers
  # GET /servers.json
  def index
    authenticate_user!
    @servers = Server.find( :all, :order => :name )

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @servers }
    end
  end

  # GET /servers/1
  # GET /servers/1.json
  def show
    authenticate_user!
    @server = Server.find(params[:id])
    @checks = @server.checks.page(params[:page]).per(10)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @server }
    end
  end

  # GET /servers/new
  # GET /servers/new.json
  def new
    authenticate_user!
    @server = Server.new
    @rackspace_servers = Server.rackspace_servers

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @server }
    end
  end

  # GET /servers/1/edit
  def edit
    authenticate_user!
    @server = Server.find(params[:id])
    @rackspace_servers = Server.rackspace_servers
  end

  # POST /servers
  # POST /servers.json
  def create
    authenticate_user!
    @server = Server.new(params[:server])

    respond_to do |format|
      if @server.save
        format.html { redirect_to @server, notice: 'Server was successfully created.' }
        format.json { render json: @server, status: :created, location: @server }
      else
        format.html { render action: "new" }
        format.json { render json: @server.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /servers/1
  # PUT /servers/1.json
  def update
    authenticate_user!
    @server = Server.find(params[:id])

    respond_to do |format|
      if @server.update_attributes(params[:server])
        format.html { redirect_to @server, notice: 'Server was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @server.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /servers/1
  # DELETE /servers/1.json
  def destroy
    authenticate_user!
    @server = Server.find(params[:id])
    @server.destroy

    respond_to do |format|
      format.html { redirect_to servers_url }
      format.json { head :no_content }
    end
  end


  # Checks all servers when URL is hit
  def check_all_servers
    @key = ENV['SECRET_KEY']
    Check.run
    render :layout => false
  end


  # Available Servers checks Rackspace for API enabled
  # Cloudservers.
  def available_servers
    authenticate_user!
    @rackspace_servers = Server.rackspace_servers
  end

end
