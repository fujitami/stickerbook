module Me
  class OwnershipsController < ApplicationController
    before_action :require_login

    def index
      ownerships = current_user.ownerships.includes(sticker: { image_attachment: :blob })
      render json: ownerships.map { |o| serialize_ownership(o) }
    end

    private

    def serialize_ownership(o)
      s = o.sticker
      {
        id: o.id,
        sticker_id: s.id,
        title: s.title,
        caption: s.caption,
        image_url: s.image.attached? ? url_for(s.image) : nil,
        author: { id: s.user.id, name: s.user.name },
        acquired_at: o.created_at.iso8601
      }
    end
  end
end