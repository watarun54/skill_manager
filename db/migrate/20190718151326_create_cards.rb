class CreateCards < ActiveRecord::Migration[5.2]
  def change
    create_table :cards do |t|
      t.belongs_to :skill, index: true
      t.integer :score
      t.text :fact

      t.timestamps
    end
  end
end
