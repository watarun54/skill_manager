class AddLineUserIdToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :line_user_id, :string
  end
end
