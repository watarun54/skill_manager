class RemoveListFromCards < ActiveRecord::Migration[5.2]
  def change
    remove_reference :cards, :list
  end
end
