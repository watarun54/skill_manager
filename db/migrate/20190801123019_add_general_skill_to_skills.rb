class AddGeneralSkillToSkills < ActiveRecord::Migration[5.2]
  def change
    add_reference :skills, :general_skill, index: true, foreign_key: true
  end
end
