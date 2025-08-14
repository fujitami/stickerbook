class User < ApplicationRecord
  has_secure_password
  before_validation { self.email = email.to_s.strip.downcase }
  validates :email, presence: true, uniqueness: { case_sensitive: false }
end
