class Card < ApplicationRecord
  belongs_to :skill

  validates :score, presence: true, numericality: { only_integer: true }
  validates :fact, presence: true, length: { maximum: 500 }

  scope :in_a_week, -> { where(created_at: 1.week.ago.beginning_of_day..Time.zone.now) }
  scope :in_a_month, -> { where(created_at: 1.month.ago.beginning_of_day..Time.zone.now) }
  scope :in_a_year, -> { where(created_at: 1.year.ago.beginning_of_day..Time.zone.now) }
end
