class List < ApplicationRecord
  belongs_to :user
  has_many :list_elements, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :user_id }, length: { maximum: 50 }
end
