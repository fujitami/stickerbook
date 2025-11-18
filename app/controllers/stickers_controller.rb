class StickersController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index, :show ]
  skip_forgery_protection only: :create

  # 他ユーザーのステッカー一覧
  def index
    if params[:user_id].present?
      # 特定ユーザーのステッカー一覧
      user = User.find(params[:user_id])
      stickers = user.stickers.with_attached_image.includes(:comments, :user).order(created_at: :desc)
    else
      # 全ユーザーのステッカー一覧
      stickers = Sticker.with_attached_image.includes(:comments, :user).order(created_at: :desc)
    end
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

  def sticker_json(s)
    ownership = current_user&.ownerships&.find_by(sticker_id: s.id)

    # current_userの存在確認とデバッグ情報の出力
    Rails.logger.debug "==== sticker_json debug ===="
    Rails.logger.debug "current_user: #{current_user&.id}"
    Rails.logger.debug "sticker: #{s.id}"
    Rails.logger.debug "ownership found: #{ownership&.id}"
    Rails.logger.debug "============================="

    {
      id: s.id,
      caption: s.caption,
      image_url: s.image.attached? ? url_for(s.image) : nil,
      owned: ownership.present?,
      ownership_id: ownership&.id
    }
  end
end
