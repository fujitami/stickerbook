class PagesController < ApplicationController
  def home
    @stickers = Sticker.includes(:user, image_attachment: :blob).order(created_at: :desc).limit(20)
  end
end
