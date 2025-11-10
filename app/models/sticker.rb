class Sticker < ApplicationRecord
  belongs_to :user
  has_many :ownerships, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_one_attached :image
  # ステッカー作成後に自動で所有関係を作る
  after_create :create_ownership_for_author

  validate :acceptable_image
  def acceptable_image
    return unless image.attached?
    if image.byte_size > 5.megabytes
      errors.add(:image, "は5MB以下にしてください")
    end
    ok = [ "image/jpeg", "image/png", "image/webp" ]
    errors.add(:image, "は JPEG/PNG/WebP のみ対応です") unless ok.include?(image.content_type)
  end

  private

  def create_ownership_for_author
    Ownership.create(user: user, sticker: self)
  end
end
