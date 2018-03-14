class SiteDeploy < ApplicationRecord
  audited

  belongs_to :site

  validates :status, presence: true, inclusion: { in: ['queued', 'started', 'finished', 'failed'] }

  def environment
    site.rails_env
  end

  def took
    if finished?
      (finished_at - started_at).to_i
    end
  end

  def finished?
    status == 'finished'
  end

  def cable_log_id
    "logs_site_deploy_#{id}"
  end
end
