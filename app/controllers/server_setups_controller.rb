class ServerSetupsController < ApplicationController
  before_action :set_server

  def index
    @setups = @server.server_setups.order("id DESC")
  end

  def show
    @setup = @server.server_setups.find(params[:id])
  end

  def create
    setup = @server.schedule_setup
    redirect_to server_setup_path(@server, setup), notice: 'Server setup queued.'
  end

  private

    def set_server
      @server = Server.find(params[:server_id])
    end
end
