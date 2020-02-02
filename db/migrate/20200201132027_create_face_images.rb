class CreateFaceImages < ActiveRecord::Migration[5.2]
  def change
    create_table :face_images do |t|
      t.references :user, foreign_key: true
      t.string :filename
      t.string :face_id

      t.timestamps
    end
  end
end
