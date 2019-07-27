class DashboardsController < ApplicationController
  def index
    @all_score_per_week = all_score_per_week
    @all_score_per_month = all_score_per_month
    @all_score_per_year = all_score_per_year

    @growth_rate_per_day = growth_rate_per_day
    @growth_rate_per_month = growth_rate_per_month
    @growth_rate_per_year = growth_rate_per_year

    @skill_score_chart_per_week = Skill.of_current_user(@current_user).map { |skill| [skill.name, skill.cards.in_a_week.sum(:score)] }
    @skill_score_chart_per_month = Skill.of_current_user(@current_user).map { |skill| [skill.name, skill.cards.in_a_month.sum(:score)] }
    @skill_score_chart_per_year = Skill.of_current_user(@current_user).map { |skill| [skill.name, skill.cards.in_a_year.sum(:score)] }
    @skill_score_chart = Skill.of_current_user(@current_user).map { |skill| [skill.name, skill.cards.sum(:score)] }

    @skill_card_chart_per_week = Skill.of_current_user(@current_user).map { |skill| [skill.name, skill.cards.in_a_week.count] }
    @skill_card_chart_per_month = Skill.of_current_user(@current_user).map { |skill| [skill.name, skill.cards.in_a_month.count] }
    @skill_card_chart_per_year = Skill.of_current_user(@current_user).map { |skill| [skill.name, skill.cards.in_a_year.count] }
    @skill_card_chart = Skill.of_current_user(@current_user).map { |skill| [skill.name, skill.cards.count] }
  end

  private

  def all_score_per_week
    time = Time.zone.now.end_of_day
    data = []
    (1..7).each do |i|
      data.unshift([time.strftime("%Y/%m/%d"), Card.of_current_user(@current_user).where("cards.created_at < ?", time).sum(:score)])
      time -= (time - i.days.ago)
    end
    data
  end

  def all_score_per_month
    time = Time.zone.now.end_of_day
    data = []
    (1..5).each do |i|
      data.unshift([time.strftime("%Y/%m"), Card.of_current_user(@current_user).where("cards.created_at < ?", time).sum(:score)])
      time -= (time - i.months.ago)
    end
    data
  end

  def all_score_per_year
    time = Time.zone.now.end_of_day
    data = []
    (1..5).each do |i|
      data.unshift([time.strftime("%Y"), Card.of_current_user(@current_user).where("cards.created_at < ?", time).sum(:score)])
      time -= (time - i.years.ago)
    end
    data
  end

  def growth_rate_per_day
    present_period = 1.day.ago..Time.zone.now
    present_score = Card.of_current_user(@current_user).where(created_at: present_period).sum(:score)
    data = []
    (1..7).each do |i|
      data.unshift([(i-1).days.ago.strftime("%Y/%m/%d"), present_score])
      present_period = (i+1).days.ago..i.days.ago
      present_score = Card.of_current_user(@current_user).where(created_at: present_period).sum(:score)
    end
    data
  end

  def growth_rate_per_month
    present_period = 1.month.ago..Time.zone.now
    present_score = Card.of_current_user(@current_user).where(created_at: present_period).sum(:score)
    data = []
    (1..5).each do |i|
      data.unshift([(i-1).months.ago.strftime("%Y/%m"), present_score])
      present_period = (i+1).months.ago..i.months.ago
      present_score = Card.of_current_user(@current_user).where(created_at: present_period).sum(:score)
    end
    data
  end

  def growth_rate_per_year
    present_period = 1.year.ago..Time.zone.now
    present_score = Card.of_current_user(@current_user).where(created_at: present_period).sum(:score)
    data = []
    (1..5).each do |i|
      data.unshift([(i-1).years.ago.strftime("%Y"), present_score])
      present_period = (i+1).years.ago..i.years.ago
      present_score = Card.of_current_user(@current_user).where(created_at: present_period).sum(:score)
    end
    data
  end
end
