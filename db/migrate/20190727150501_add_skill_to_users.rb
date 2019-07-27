class AddSkillToUsers < ActiveRecord::Migration[5.2]
  def change
    add_reference :users, :skill, index: true, foreign_key: true
  end
end
