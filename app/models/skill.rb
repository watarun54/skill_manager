class Skill < ApplicationRecord
  has_many :cards, :dependent => :delete_all

  validates :name, presence: true, uniqueness: true, length: { in: 1..50 }
end
