class DashboardsController < ApplicationController
  def index
    @skill_score_chart_per_week = Skill.all.map { |skill| [skill.name, skill.cards.in_a_week.sum(:score)] }
    @skill_score_chart_per_month = Skill.all.map { |skill| [skill.name, skill.cards.in_a_month.sum(:score)] }
    @skill_score_chart_per_year = Skill.all.map { |skill| [skill.name, skill.cards.in_a_year.sum(:score)] }


    @skill_card_chart = Skill.all.map { |skill| [skill.name, skill.cards.count] }
  end
end
