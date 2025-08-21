class UsersController < ApplicationController
  skip_forgery_protection if: -> { request.format.json? }

  def create
    user = User.new(user_params)
    if user.save
      session[:user_id] = user.id
      render json: { id: user.id, email: user.email }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private
  def user_params
    params.permit(:email, :password, :password_confirmation)
  end
end
