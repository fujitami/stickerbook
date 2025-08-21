class Sticker < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  validate :acceptable_image
  def acceptable_image
    return unless image.attached?
    if image.byte_size > 5.megabytes
      errors.add(:image, "は5MB以下にしてください")
    end
    ok = [ "image/jpeg", "image/png", "image/webp" ]
    errors.add(:image, "は JPEG/PNG/WebP のみ対応です") unless ok.include?(image.content_type)
  end
end
