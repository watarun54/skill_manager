class GeneralSkill < ApplicationRecord
  has_many :skills, dependent: :delete_all
  has_many :papers, dependent: :delete_all
  belongs_to :user

  validates :name, presence: true, uniqueness: { scope: :user_id }, length: { maximum: 50 }

  scope :of_current_user, ->(current_user) { current_user.general_skills }
end
