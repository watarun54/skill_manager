class Card < ApplicationRecord
  belongs_to :skill
  belongs_to :list

  validates :score, presence: true, numericality: { only_integer: true }
  validates :fact, presence: true, length: { maximum: 500 }

  scope :of_current_user, ->(current_user) { eager_load(:skill).where(skills: { user_id: current_user.id }) }
  scope :of_general_skill, ->(general_skill) { eager_load(:skill).where(skills: { general_skill_id: general_skill.id }) unless general_skill.nil? }
  scope :of_skill, ->(skill_id) { joins(:skill).where(skills: {id: skill_id}) unless skill_id.blank? }

  scope :in_a_week, -> { where(created_at: 1.week.ago.beginning_of_day..Time.zone.now) }
  scope :in_a_month, -> { where(created_at: 1.month.ago.beginning_of_day..Time.zone.now) }
  scope :in_a_year, -> { where(created_at: 1.year.ago.beginning_of_day..Time.zone.now) }
end
