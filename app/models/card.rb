class Card < ApplicationRecord
  belongs_to :skill

  validates :score, presence: true, numericality: { only_integer: true }
  validates :fact, presence: true, length: { in: 1..500 } 
end
