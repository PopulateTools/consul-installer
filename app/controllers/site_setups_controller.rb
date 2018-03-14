class SiteSetupsController < ApplicationController
  before_action :set_site

  def index
    @setups = @site.site_setups.order("id DESC")
  end

  def show
    @setup = @site.site_setups.find(params[:id])
  end

  def create
    setup = @site.schedule_setup
    redirect_to site_setup_path(@site, setup), notice: 'Site setup queued.'
  end

  private

    def set_site
      @site = Site.find(params[:site_id])
    end
end
