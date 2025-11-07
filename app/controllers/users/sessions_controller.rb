# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  respond_to :json
  skip_before_action :authenticate_user!, only: [:create]

  private

  def respond_with(resource, _opts = {})
    if resource.persisted?
      render json: { status: { code: 200, message: 'Logged in successfully.' },
                     data: resource.as_json(only: [:id, :email]) }, status: :ok
    else
      render json: { status: { message: "Invalid email or password." } }, status: :unauthorized
    end
  end

  def respond_to_on_destroy
    render json: { status: 200, message: "Logged out successfully." }, status: :ok
  end
end