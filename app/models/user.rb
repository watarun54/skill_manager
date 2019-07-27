class User < ApplicationRecord
  has_secure_password validations: true

  validates :email, presence: true, uniqueness: true
end
