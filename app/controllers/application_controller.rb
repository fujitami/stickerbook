class ApplicationController < ActionController::Base
  include Devise::Controllers::Helpers
  # APIやcurlからのJSONリクエストではCSRF検証をスキップ
  protect_from_forgery with: :exception, unless: :json_request?
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token, if: :json_request?

  # セッション表示用のデバッグアクション
  def debug_session
    render json: { user_signed_in: user_signed_in?, current_user: current_user }
  end

  private
  def current_user
    if respond_to?(:warden)
      warden_user = warden.user(:user) rescue nil
      return warden_user if warden_user.present?
    end

    @current_user ||= User.find_by(id: session[:user_id])
  end

  def json_request?
    request.format.json? || request.content_type == "application/json"
  end
end
