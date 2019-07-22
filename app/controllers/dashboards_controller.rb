class DashboardsController < ApplicationController
  def index
    @skill_score_chart = Skill.all.map { |skill| [skill.name, skill.cards.sum(:score)] }
    @skill_card_chart = Skill.all.map { |skill| [skill.name, skill.cards.count] }
  end
end
