class SiteDeployJob < ApplicationJob
  queue_as :default

  def perform(site_deploy_id)
    site_deploy = SiteDeploy.find(site_deploy_id)
    SiteDeployRunner.new(site_deploy).run
  end
end
