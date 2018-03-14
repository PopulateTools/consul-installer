class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include SessionsHelper

  before_action :authenticate_user!

  private

  def authenticate_user!
    unless logged_in?
      redirect_to login_url
    end
  end

  def require_admin!
    unless logged_in? && current_user.admin?
      flash[:error] = "Not authorized"
      redirect_to login_url
    end
  end
end
