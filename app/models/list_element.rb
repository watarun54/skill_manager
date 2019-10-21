class ListElement < ApplicationRecord
  belongs_to :list
  has_many :cards

  validates :name, presence: true, length: { maximum: 50 }
end
