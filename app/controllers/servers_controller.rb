class ServersController < ApplicationController
  before_action :set_server, only: [:show, :edit, :update, :destroy, :setup]

  # GET /servers
  def index
    @servers = Server.all
  end

  # GET /servers/1
  def show
  end

  # GET /servers/new
  def new
    @server = Server.new
  end

  # GET /servers/1/edit
  def edit
  end

  # POST /servers
  def create
    @server = Server.new(server_params)

    if @server.save
      setup = @server.schedule_setup
      redirect_to server_setup_path(@server, setup), notice: 'Server was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /servers/1
  def update
    if @server.update(server_params)
      redirect_to @server, notice: 'Server was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /servers/1
  def destroy
    if @server.destroy
      redirect_to servers_url, notice: 'Server was successfully destroyed.'
    else
      redirect_to servers_url, notice: "Server couldn't be destroyed (it has associated sites)."
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_server
      @server = Server.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def server_params
      params.require(:server).permit(:name, :ip, :server_type)
    end
end
