class SiteSetupJob < ApplicationJob
  queue_as :default

  def perform(site_setup_id)
    site_setup = SiteSetup.find(site_setup_id)
    SiteSetupRunner.new(site_setup).run
  end
end
