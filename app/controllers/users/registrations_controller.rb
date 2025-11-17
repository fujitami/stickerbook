# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json
  skip_before_action :verify_authenticity_token

  def create
    build_resource(sign_up_params)

    if resource.save
      sign_in(resource)
      render json: { message: "Signed up.", user: resource }, status: :ok
    else
      render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
