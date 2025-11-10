class Ownership < ApplicationRecord
  belongs_to :user
  belongs_to :sticker
  validates :sticker_id, uniqueness: { scope: :user_id }
end
