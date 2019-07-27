class Skill < ApplicationRecord
  has_many :cards, :dependent => :delete_all

  validates :name, presence: true, uniqueness: true, length: { maximum: 50 }
end
