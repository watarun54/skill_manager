class GeneralSkillsController < ApplicationController
  before_action :set_general_skill, only: [:show, :edit, :update, :destroy, :show_skill_charts]
  before_action :redirect_if_not_having_gs, only: [:show]

  def index
    @general_skill = GeneralSkill.new
    @general_skills = GeneralSkill.of_current_user(@current_user).order(id: "DESC")
  end

  def show
    dashboard
  end

  def new

  end

  def create
		@general_skill = GeneralSkill.new(general_skill_params)
    @general_skill.user = @current_user

		respond_to do |format|
			if @general_skill.save
        format.html { render :index }
        format.json { render :index, status: :created, location: @general_skill }
        format.js { @status = "success"}
      else
        format.html { render :index }
        format.json { render json: @general_skill.errors, status: :unprocessable_entity }
        format.js { @status = "fail" }
      end
    end
  end

  def edit

  end

  def update
    respond_to do |format|
			if @general_skill.update(general_skill_params)
        format.html { render :index }
        format.json { render :index, status: :created, location: @general_skill }
        format.js { @status = "success"}
      else
        format.html { render :index }
        format.json { render json: @general_skill.errors, status: :unprocessable_entity }
        format.js { @status = "fail" }
      end
    end
  end

  def destroy
		respond_to do |format|
			if @general_skill.destroy
        format.html { render :index }
        format.js { @status = "success"}
      else
        format.html { render :index }
        format.js { @status = "fail" }
      end
    end
  end

  def show_skill_charts
    @selected_skill = Skill.find(params["skill_id"])
    @charts_by_skill_data = {}
    @charts_by_skill_data["skill_score_chart_per_week"] = all_score_per_week(@selected_skill)
    @charts_by_skill_data["skill_score_chart_per_month"] = all_score_per_month(@selected_skill)
    @charts_by_skill_data["skill_score_chart_per_year"] = all_score_per_year(@selected_skill)

    @charts_by_skill_data["skill_card_chart_per_week"] = growth_rate_per_day(@selected_skill)
    @charts_by_skill_data["skill_card_chart_per_month"] = growth_rate_per_month(@selected_skill)
    @charts_by_skill_data["skill_card_chart_per_year"] = growth_rate_per_year(@selected_skill)
  end

  private

  def general_skill_params
    params.require(:general_skill).permit(:name)
  end

  def set_general_skill
    @general_skill = GeneralSkill.find(params[:id])
  end

  def redirect_if_not_having_gs
    redirect_to :root if @general_skill.user_id != @current_user.id
  end

  def dashboard
    @data_scores = {
      labels: @current_user.general_skills.pluck(:name),
      datasets: [
        {
          label: "All card scores of General Skill",
          background_color: "rgba(220,220,220,0.2)",
          border_color: "rgba(220,220,220,1)",
          data: @current_user.general_skills.map { |gs| gs.skills.map{ |skill| skill.cards.sum(:score) }.sum }
        },
      ]
    }
    @options_scores = {
      id: "radar_scores",
      responsive: true,
      maintainAspectRatio: false,
      scale: {
        ticks: {
            beginAtZero: true,
            min: 0
        }
      }
    }

    @data_count = {
      labels: @current_user.general_skills.pluck(:name),
      datasets: [
        {
          label: "All card count of General Skill",
          backgroundColor: "rgba(151,187,205,0.2)",
          borderColor: "rgba(151,187,205,1)",
          data: @current_user.general_skills.map { |gs| gs.skills.map{ |skill| skill.cards.count }.sum }
        },
      ]
    }
    @options_count = {
      id: "radar_count",
      responsive: true,
      maintainAspectRatio: false,
      scale: {
        ticks: {
            beginAtZero: true,
            min: 0
        }
      }
    }

    @selected_skill = @general_skill.skills.first
    # All Cards
    @all_score_per_week = all_score_per_week(@selected_skill)
    @all_score_per_month = all_score_per_month(@selected_skill)
    @all_score_per_year = all_score_per_year(@selected_skill)

    @growth_rate_per_day = growth_rate_per_day(@selected_skill)
    @growth_rate_per_month = growth_rate_per_month(@selected_skill)
    @growth_rate_per_year = growth_rate_per_year(@selected_skill)

    # All Skills
    @skill_score_chart_per_week = @general_skill.skills.map { |skill| [skill.name, skill.cards.in_a_week.sum(:score)] }
    @skill_score_chart_per_month = @general_skill.skills.map { |skill| [skill.name, skill.cards.in_a_month.sum(:score)] }
    @skill_score_chart_per_year = @general_skill.skills.map { |skill| [skill.name, skill.cards.in_a_year.sum(:score)] }
    @skill_score_chart = @general_skill.skills.map { |skill| [skill.name, skill.cards.sum(:score)] }

    @skill_card_chart_per_week = @general_skill.skills.map { |skill| [skill.name, skill.cards.in_a_week.count] }
    @skill_card_chart_per_month = @general_skill.skills.map { |skill| [skill.name, skill.cards.in_a_month.count] }
    @skill_card_chart_per_year = @general_skill.skills.map { |skill| [skill.name, skill.cards.in_a_year.count] }
    @skill_card_chart = @general_skill.skills.map { |skill| [skill.name, skill.cards.count] }

    # 各スキル
    @charts_by_skill_data = {}
    @charts_by_skill_data["skill_score_chart_per_week"] = all_score_per_week(@selected_skill)
    @charts_by_skill_data["skill_score_chart_per_month"] = all_score_per_month(@selected_skill)
    @charts_by_skill_data["skill_score_chart_per_year"] = all_score_per_year(@selected_skill)

    @charts_by_skill_data["skill_card_chart_per_week"] = growth_rate_per_day(@selected_skill)
    @charts_by_skill_data["skill_card_chart_per_month"] = growth_rate_per_month(@selected_skill)
    @charts_by_skill_data["skill_card_chart_per_year"] = growth_rate_per_year(@selected_skill)

    # Growth of Skills
    all_skills_chart
  end

  def all_score_per_week(skill)
    time = Time.zone.now.end_of_day
    data = []
    (1..7).each do |i|
      if skill.nil?
        data.unshift([time.strftime("%Y/%m/%d"), Card.of_general_skill(@general_skill).where("cards.created_at < ?", time).sum(:score)])
      else
        data.unshift([time.strftime("%Y/%m/%d"), skill.cards.of_current_user(@current_user).where("cards.created_at < ?", time).sum(:score)])
      end
      time -= (time - i.days.ago)
    end
    data
  end

  def all_score_per_month(skill)
    time = Time.zone.now.end_of_day
    data = []
    (1..5).each do |i|
      if skill.nil?
        data.unshift([time.strftime("%Y/%m"), Card.of_general_skill(@general_skill).where("cards.created_at < ?", time).sum(:score)])
      else
        data.unshift([time.strftime("%Y/%m"), skill.cards.of_current_user(@current_user).where("cards.created_at < ?", time).sum(:score)])
      end
      time -= (time - i.months.ago)
    end
    data
  end

  def all_score_per_year(skill)
    time = Time.zone.now.end_of_day
    data = []
    (1..5).each do |i|
      if skill.nil?
        data.unshift([time.strftime("%Y"), Card.of_general_skill(@general_skill).where("cards.created_at < ?", time).sum(:score)])
      else
        data.unshift([time.strftime("%Y"), skill.cards.of_current_user(@current_user).where("cards.created_at < ?", time).sum(:score)])
      end
      time -= (time - i.years.ago)
    end
    data
  end

  def growth_rate_per_day(skill)
    present_period = 1.day.ago..Time.zone.now
    if skill.nil?
      present_score = Card.of_general_skill(@general_skill).where(created_at: present_period).sum(:score)
    else
      present_score = skill.cards.of_current_user(@current_user).where(created_at: present_period).sum(:score)
    end
    data = []
    (1..7).each do |i|
      data.unshift([(i-1).days.ago.strftime("%Y/%m/%d"), present_score])
      present_period = (i+1).days.ago..i.days.ago
      if skill.nil?
        present_score = Card.of_general_skill(@general_skill).where(created_at: present_period).sum(:score)
      else
        present_score = skill.cards.of_current_user(@current_user).where(created_at: present_period).sum(:score)
      end
    end
    data
  end

  def growth_rate_per_month(skill)
    present_period = 1.month.ago..Time.zone.now
    if skill.nil?
      present_score = Card.of_general_skill(@general_skill).where(created_at: present_period).sum(:score)
    else
      present_score = skill.cards.of_current_user(@current_user).where(created_at: present_period).sum(:score)
    end
    data = []
    (1..5).each do |i|
      data.unshift([(i-1).months.ago.strftime("%Y/%m"), present_score])
      present_period = (i+1).months.ago..i.months.ago
      if skill.nil?
        present_score = Card.of_general_skill(@general_skill).where(created_at: present_period).sum(:score)
      else
        present_score = skill.cards.of_current_user(@current_user).where(created_at: present_period).sum(:score)
      end
    end
    data
  end

  def growth_rate_per_year(skill)
    present_period = 1.year.ago..Time.zone.now
    if skill.nil?
      present_score = Card.of_general_skill(@general_skill).where(created_at: present_period).sum(:score)
    else
      present_score = skill.cards.of_current_user(@current_user).where(created_at: present_period).sum(:score)
    end
    data = []
    (1..5).each do |i|
      data.unshift([(i-1).years.ago.strftime("%Y"), present_score])
      present_period = (i+1).years.ago..i.years.ago
      if skill.nil?
        present_score = Card.of_general_skill(@general_skill).where(created_at: present_period).sum(:score)
      else
        present_score = skill.cards.of_current_user(@current_user).where(created_at: present_period).sum(:score)
      end
    end
    data
  end

  def all_skills_chart
    @all_skills_chart = {}
    @all_skills_chart["all_skills_chart_per_week"] = growth_rate_per_day_in_all_skills
    @all_skills_chart["all_skills_chart_per_month"] = growth_rate_per_month_in_all_skills
    @all_skills_chart["all_skills_chart_per_year"] = growth_rate_per_year_in_all_skills
  end

  def growth_rate_per_day_in_all_skills
    result = []
    @general_skill.skills.each do |skill|
      present_period = 1.day.ago..Time.zone.now
      present_score = skill.cards.of_current_user(@current_user).where(created_at: present_period).sum(:score)
      data = []
      (1..7).each do |i|
        data.unshift([(i-1).days.ago.strftime("%Y/%m/%d"), present_score])
        present_period = (i+1).days.ago..i.days.ago
        present_score = skill.cards.of_current_user(@current_user).where(created_at: present_period).sum(:score)
      end
      result << { "name": skill.name, "data": data }
    end
    result
  end

  def growth_rate_per_month_in_all_skills
    result = []
    @general_skill.skills.each do |skill|
      present_period = 1.month.ago..Time.zone.now
      present_score = skill.cards.of_current_user(@current_user).where(created_at: present_period).sum(:score)
      data = []
      (1..5).each do |i|
        data.unshift([(i-1).months.ago.strftime("%Y/%m"), present_score])
        present_period = (i+1).months.ago..i.months.ago
        present_score = skill.cards.of_current_user(@current_user).where(created_at: present_period).sum(:score)
      end
      result << { "name": skill.name, "data": data }
    end
    result
  end

  def growth_rate_per_year_in_all_skills
    result = []
    @general_skill.skills.each do |skill|
      present_period = 1.year.ago..Time.zone.now
      present_score = skill.cards.of_current_user(@current_user).where(created_at: present_period).sum(:score)
      data = []
      (1..5).each do |i|
        data.unshift([(i-1).years.ago.strftime("%Y"), present_score])
        present_period = (i+1).years.ago..i.years.ago
        present_score = skill.cards.of_current_user(@current_user).where(created_at: present_period).sum(:score)
      end
      result << { "name": skill.name, "data": data }
    end
    result
  end
end
