class SiteSetup < ApplicationRecord
  audited

  belongs_to :site

  validates :site, presence: true
  validates :started_at, presence: true

  before_validation :set_default_values

  def set_default_values
    self.status ||= 'queued'
    self.started_at ||= Time.current
  end

  def took
    return unless finished_at.present?

    finished_at - started_at
  end

  def cable_log_id
    "logs_site_setup_#{id}"
  end
end
