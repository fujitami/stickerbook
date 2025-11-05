class StickersController < ApplicationController
  before_action :require_login, except: [ :index, :show ]
  skip_forgery_protection only: :create

  # 他ユーザーのステッカー一覧
  def index
    user = User.find(params[:user_id])
    stickers = user.stickers.with_attached_image.includes(:comments, :user).order(created_at: :desc)
    render json: stickers.map { |s| sticker_json(s) }
  end

  # ログイン中ユーザーのステッカー一覧
  def my_index
    stickers = current_user.stickers.with_attached_image.includes(:comments, :user).order(created_at: :desc)
    render json: stickers.map { |s| sticker_json(s) }
  end

  # ステッカー詳細
  def show
    s = Sticker.find(params[:id])
    render json: sticker_json(s)
  end

  # ステッカー作成
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

  # def sticker_json(s)
  #   {
  #     id: s.id,
  #     user_id: s.user_id,
  #     user_name: s.user.name,
  #     caption: s.caption,
  #     image_url: (s.image.attached? ? url_for(s.image) : nil),
  #     comments: s.comments.map { |c|
  #       {
  #         id: c.id,
  #         body: c.body,
  #         user: { id: c.user.id, name: c.user.name }
  #       }
  #     },
  #     created_at: s.created_at.iso8601
  #   }
  # end

  def sticker_json(s)
    {
      id: s.id,
      caption: s.caption,
      user_name: s.user.name,
      image_url: s.image.attached? ? url_for(s.image) : nil
    }
  end
end
