class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable
  has_many :stickers, dependent: :destroy
  has_many :ownerships, dependent: :destroy
  has_many :comments, dependent: :destroy

  before_validation { self.email = email.to_s.strip.downcase }
  validates :email, presence: true, uniqueness: { case_sensitive: false }
end
