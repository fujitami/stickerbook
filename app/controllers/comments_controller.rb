class CommentsController < ApplicationController
  before_action :require_login
  skip_forgery_protection if: -> { request.format.json? }

  def index
    sticker = Sticker.find(params[:sticker_id])
    comments = sticker.comments.includes(:user)
    render json: comments.map { |c| serialize(c) }
  end

  def create
    sticker = Sticker.find(params[:sticker_id])
    comment = sticker.comments.build(user: current_user, body: params[:body])
    if comment.save
      render json: serialize(comment), status: :created
    else
      render json: { errors: comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def serialize(comment)
    {
      id: comment.id,
      body: comment.body,
      user: { id: comment.user.id, name: comment.user.name }
    }
  end
end
