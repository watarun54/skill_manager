class CreateListElements < ActiveRecord::Migration[5.2]
  def change
    create_table :list_elements do |t|
      t.string :name
      t.references :list, foreign_key: true

      t.timestamps
    end
  end
end
