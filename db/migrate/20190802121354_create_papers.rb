class CreatePapers < ActiveRecord::Migration[5.2]
  def change
    create_table :papers do |t|
      t.string :title
      t.text :content
      t.integer :status, default: 0
      t.text :url
      t.references :user, foreign_key: true
      t.references :general_skill

      t.timestamps
    end
  end
end
