class Site < ApplicationRecord
  VALID_RAILS_ENVS = %w(production staging)
  DEFAULT_CENSUS_API_HOSTS = {
    production: {
      api_token_host: "",
      api_endpoint: ""
    },
    staging: {
      api_token_host: "",
      api_endpoint: ""
    }
  }
  audited

  has_many :site_setups, dependent: :destroy
  has_many :site_deploys, dependent: :destroy

  belongs_to :web_server, class_name: 'Server', foreign_key: :web_server_id
  belongs_to :app_server, class_name: 'Server', foreign_key: :app_server_id
  belongs_to :db_server, class_name: 'Server', foreign_key: :db_server_id

  validates :name, presence: true, uniqueness: true, format: { with: /\A[0-9a-zA-Z_]*\Z/ }
  validates :repo_url, presence: true
  validates :rails_env, presence: true, inclusion: { in: VALID_RAILS_ENVS}
  validates :host, presence: true, uniqueness: true
  validates :base_path, presence: true, uniqueness: true, format: { with: /\A[0-9a-zA-Z_]*\Z/ }
  validates :db_name, presence: true, uniqueness: true, format: { with: /\A[0-9a-zA-Z_]*\Z/ }
  validates :db_user, presence: true
  validates :db_password, presence: true
  validates :web_server, presence: true
  validates :app_server, presence: true
  validates :db_server, presence: true

  before_validation :set_values

  def set_values
    self.db_name ||= base_path
    self.db_user ||= base_path
    self.db_password ||= SecureRandom.hex
    self.secret_key_base ||= SecureRandom.hex(64)
    self.census_api_token_host ||= DEFAULT_CENSUS_API_HOSTS[self.rails_env.to_sym][:api_token_host]
    self.census_api_endpoint ||= DEFAULT_CENSUS_API_HOSTS[self.rails_env.to_sym][:api_endpoint]
  end

  def db_host
    db_server.ip
  end

  def unicorn_host
    app_server.ip
  end

  def unicorn_port
    5000 + id
  end

  def last_deploys
    site_deploys.order("id DESC").limit(5)
  end

  def last_setups
    site_setups.order("id DESC").limit(5)
  end

  def schedule_setup
    setup = site_setups.create!(status: 'queued')
    SiteSetupJob.perform_later(setup.id)
    setup
  end

  def schedule_deploy
    deploy = site_deploys.create!(status: 'queued')
    SiteDeployJob.perform_later(deploy.id)
    deploy
  end
end
