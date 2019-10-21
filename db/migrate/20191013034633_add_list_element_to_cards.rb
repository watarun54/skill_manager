class AddListElementToCards < ActiveRecord::Migration[5.2]
  def change
    add_reference :cards, :list_element
  end
end
