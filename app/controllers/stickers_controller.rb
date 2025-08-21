class StickersController < ApplicationController
  before_action :require_login

  skip_forgery_protection only: :create

  def index
    stickers = current_user.stickers.with_attached_image.order(created_at: :desc)
    render json: stickers.map { |s| sticker_json(s) }
  end

  def show
    s = current_user.stickers.find(params[:id])
    render json: sticker_json(s)
  end

  def create
    s = current_user.stickers.build(caption: params[:caption])

    s.image.attach(params[:image]) if params[:image].present?

    if s.save
      render json: sticker_json(s), status: :created
    else
      render json: { errors: s.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def sticker_json(s)
    {
      id: s.id,
      caption: s.caption,
      image_url: (s.image.attached? ? url_for(s.image) : nil),
      created_at: s.created_at.iso8601
    }
  end
end