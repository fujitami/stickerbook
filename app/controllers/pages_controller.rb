class PagesController < ApplicationController
  skip_before_action :verify_authenticity_token, if: :json_request?
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
    @stickers = Sticker.includes(:user, image_attachment: :blob).order(created_at: :desc).limit(20)
  end
end
