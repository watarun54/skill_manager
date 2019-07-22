module SkillsHelper
  def total_scores_of(skill)
    skill.cards.sum(:score)
  end
end
