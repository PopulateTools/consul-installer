ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  def is_logged_in?
    !session[:user_id].nil?
  end

  def log_in_as(user)
    post login_url, params: { session: { username: "one", password: "12345678" }}
  end
end

module FixtureHelpers
  def user_password
    "12345678"
  end

  def user_password_digest
    BCrypt::Password.create(user_password, cost: 4)
  end
end
ActiveRecord::FixtureSet.context_class.include FixtureHelpers
