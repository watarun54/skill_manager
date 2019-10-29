class ListElement < ApplicationRecord
  include RankedModel

  belongs_to :list
  has_many :cards
  ranks :row_order, with_same: :list_id

  validates :name, presence: true, length: { maximum: 50 }
end
