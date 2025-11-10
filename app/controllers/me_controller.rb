class MeController < ApplicationController
  before_action :authenticate_user!

  def show
    render json: {
      id: current_user.id,
      email: current_user.email,
      stickers_count: current_user.stickers.count
    }
  end
end
