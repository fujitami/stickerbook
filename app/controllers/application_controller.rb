class ApplicationController < ActionController::Base
  # include Devise::Controllers::Helpers
  protect_from_forgery with: :exception
  skip_forgery_protection if: -> { request.format.json? }
  # helper_method :current_user

  def authenticate_user!
    require_login
  end

  private
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def require_login
    head :unauthorized unless current_user
  end
end
