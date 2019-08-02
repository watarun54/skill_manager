class Paper < ApplicationRecord
  belongs_to :user
  belongs_to :general_skill

  validates :title, length: { maximum: 100 }
  validates :content, length: { maximum: 500 }
  validates :url, length: { maximum: 300 }
  validates :user_id, presence: true

  scope :of_current_user, ->(current_user) { current_user.papers }
end
