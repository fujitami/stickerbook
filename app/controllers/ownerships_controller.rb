class OwnershipsController < ApplicationController
  before_action :require_login
  skip_forgery_protection if: -> { request.format.json? }

  def create
    sticker = Sticker.find(params[:sticker_id])
    ownership = current_user.ownerships.build(sticker:)

    if ownership.save
      render json: { message: "owned", sticker_id: sticker.id }, status: :created
    else
      render json: { errors: ownership.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    ownership = current_user.ownerships.find_by(id: params[:id])
    if ownership
      ownership.destroy
      head :no_content
    else
      head :not_found
    end
  end
end