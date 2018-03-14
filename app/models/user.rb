class User < ApplicationRecord
  audited except: [:password, :password_digest]
  has_secure_password

  validates :username,  presence: true, length: { maximum: 50 }
  validates :password, presence: true, length: { minimum: 8 }
end
