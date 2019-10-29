class AddRowOrderToListElements < ActiveRecord::Migration[5.2]
  def change
    add_column :list_elements, :row_order, :integer
  end
end
