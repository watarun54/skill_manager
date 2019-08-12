module GeneralSkillsHelper
  def total_score_of_all_cards_in(gs)
    gs.skills.map {|skill| skill.cards.sum(:score) }.sum
  end
  def total_num_of_all_cards_in(gs)
    gs.skills.map {|skill| skill.cards.count }.sum
  end
end
