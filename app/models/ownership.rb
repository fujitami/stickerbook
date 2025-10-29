class Ownership < ApplicationRecord
  belongs_to :user
  belongs_to :sticker
  validates :user_id, uniqueness: { scope: :sticker_id }
end
