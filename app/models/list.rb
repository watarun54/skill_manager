class List < ApplicationRecord
  has_many :cards

  validates :name, presence: true, uniqueness: { scope: :user_id }, length: { maximum: 50 }
end
