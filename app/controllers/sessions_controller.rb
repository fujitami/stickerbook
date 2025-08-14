class SessionsController < ApplicationController
  skip_forgery_protection if: -> { request.format.json? }

  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id 
      render json: { message: "logged_in" }, status: :ok
    else
      render json: { message: "invalid_credentials" }, status: :unauthorized
    end
  end

  def destroy
    reset_session
    head :no_content
  end
end