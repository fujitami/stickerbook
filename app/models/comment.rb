class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :sticker

  validates :body, presence: true
end
