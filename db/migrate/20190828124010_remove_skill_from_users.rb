class RemoveSkillFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_reference :users, :skill, foreign_key: true
  end
end
