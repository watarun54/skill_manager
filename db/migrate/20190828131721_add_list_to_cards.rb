class AddListToCards < ActiveRecord::Migration[5.2]
  def change
    add_reference :cards, :list
  end
end
