class Server < ApplicationRecord
  SERVER_TYPES = %w(application web database all)
  SERVER_STATUSES = %w(new installing installed failed)

  audited

  has_many :server_setups, dependent: :destroy
  has_many :sites_as_web_server, dependent: :restrict_with_error, class_name: "Site", foreign_key: :web_server_id
  has_many :sites_as_app_server, dependent: :restrict_with_error, class_name: "Site", foreign_key: :app_server_id
  has_many :sites_as_db_server, dependent: :restrict_with_error, class_name: "Site", foreign_key: :db_server_id

  validates :name, presence: true, uniqueness: true
  validates :ip, presence: true, uniqueness: true
  validates :server_type, presence: true, inclusion: { in: SERVER_TYPES }
  validates :status, presence: true, inclusion: { in: SERVER_STATUSES }

  before_validation :set_status

  scope :web_servers, -> { where(server_type: 'web') }
  scope :app_servers, -> { where(server_type: 'application') }
  scope :db_servers,  -> { where(server_type: 'database') }
  scope :full_stack_servers, -> { where(server_type: 'all') }

  def set_status
    self.status ||= 'new'
  end

  def sites
    Site.where("web_server_id = ? OR app_server_id = ? OR db_server_id = ?", id, id, id)
  end

  def last_setups
    server_setups.order("id DESC").limit(5)
  end

  def schedule_setup
    setup = server_setups.create!(status: 'queued')
    ServerSetupJob.perform_later(setup.id)
    setup
  end
end
