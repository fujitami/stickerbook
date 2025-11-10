class OwnershipsController < ApplicationController
  before_action :authenticate_user!
  skip_forgery_protection

  def create
    sticker = Sticker.find(params[:sticker_id])
    ownership = current_user.ownerships.create(sticker: sticker)

    if ownership.persisted?
      render json: { message: "owned", sticker_id: sticker.id }, status: :created
    else
      render json: { errors: ownership.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    ownership = current_user.ownerships.find_by(id: params[:id])
    if ownership&.destroy
      head :no_content
    else
      render json: { error: "Not found or not owned" }, status: :not_found
    end
  end
end
