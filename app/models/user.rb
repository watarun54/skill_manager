class User < ApplicationRecord
  has_secure_password validations: true
  has_many :skills, dependent: :destroy
  has_many :general_skills, dependent: :destroy
  has_many :papers, dependent: :destroy
  has_many :lists, dependent: :destroy

  has_one :face_image, dependent: :destroy

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false },
                    length: { maximum: 191 }
  validates :line_user_id, uniqueness: true, allow_nil: true, length: { maximum: 100 }

  before_validation :set_line_user_id, only: :update

  def self.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def self.encrypt(token)
    Digest::SHA256.hexdigest(token.to_s)
  end

  private

  def set_line_user_id
    self.line_user_id = nil if line_user_id.blank?
  end
end
