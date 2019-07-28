class AddUserToSkills < ActiveRecord::Migration[5.2]
  def change
    add_reference :skills, :user, index: true, foreign_key: true
  end
end
