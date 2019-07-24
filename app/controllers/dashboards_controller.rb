class DashboardsController < ApplicationController
  def index
    @all_score_per_week = all_score_per_week
    @all_score_per_month = all_score_per_month
    @all_score_per_year = all_score_per_year

    @skill_score_chart_per_week = Skill.all.map { |skill| [skill.name, skill.cards.in_a_week.sum(:score)] }
    @skill_score_chart_per_month = Skill.all.map { |skill| [skill.name, skill.cards.in_a_month.sum(:score)] }
    @skill_score_chart_per_year = Skill.all.map { |skill| [skill.name, skill.cards.in_a_year.sum(:score)] }

    @skill_card_chart_per_week = Skill.all.map { |skill| [skill.name, skill.cards.in_a_week.count] }
    @skill_card_chart_per_month = Skill.all.map { |skill| [skill.name, skill.cards.in_a_month.count] }
    @skill_card_chart_per_year = Skill.all.map { |skill| [skill.name, skill.cards.in_a_year.count] }
  end

  private

  def all_score_per_week
    time = Time.zone.now.end_of_day
    data = []
    (1..7).each do |i|
      data.unshift([time.strftime("%Y/%m/%d"), Card.where("created_at < ?", time).sum(:score)])
      time -= (time - i.days.ago)
    end
    data
  end

  def all_score_per_month
    time = Time.zone.now.end_of_day
    data = []
    (1..5).each do |i|
      data.unshift([time.strftime("%Y/%m"), Card.where("created_at < ?", time).sum(:score)])
      time -= (time - i.months.ago)
    end
    data
  end

  def all_score_per_year
    time = Time.zone.now.end_of_day
    data = []
    (1..5).each do |i|
      data.unshift([time.strftime("%Y"), Card.where("created_at < ?", time).sum(:score)])
      time -= (time - i.years.ago)
    end
    data
  end
end
