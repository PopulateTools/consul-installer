class SiteDeploysController < ApplicationController
  before_action :set_site

  def index
    @deploys = @site.site_deploys.order("id DESC")
  end

  def show
    @deploy = @site.site_deploys.find(params[:id])
  end

  def create
    deploy = @site.schedule_deploy
    redirect_to site_deploy_path(@site, deploy), notice: 'Site deploy queued.'
  end

  private

    def set_site
      @site = Site.find(params[:site_id])
    end
end
