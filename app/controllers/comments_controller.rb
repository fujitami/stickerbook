class CommentsController < ApplicationController
  # include Devise::Controllers::Helpers
  before_action :authenticate_user!, only: [:create]
  # skip_forgery_protection if: -> { request.format.json? }
  skip_before_action :verify_authenticity_token, only: [:create]

  def index
    sticker = Sticker.find(params[:sticker_id])
    comments = sticker.comments.includes(:user)
    render json: comments.map { |c| comment_json(c) }
  end

  def create
    sticker = Sticker.find(params[:sticker_id])
    comment = sticker.comments.build(comment_params.merge(user: current_user))
    if comment.save
      render json: comment_json(comment), status: :created
    else
      render json: { errors: comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def comment_json(comment)
    {
      id: comment.id,
      body: comment.body,
      user: { id: comment.user.id, email: comment.user.email },
    }
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end