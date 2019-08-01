class Skill < ApplicationRecord
  has_many :cards, dependent: :delete_all
  belongs_to :user
  belongs_to :general_skill

  validates :name, presence: true, uniqueness: { scope: :user_id }, length: { maximum: 50 }

  scope :of_current_user, ->(current_user) { current_user.skills }
end
