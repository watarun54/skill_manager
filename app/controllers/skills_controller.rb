class SkillsController < ApplicationController
  before_action :set_skill, only: [:edit, :update, :destroy]
  before_action :set_options, only: [:index, :edit]

  PER = 20

  def index
    @skill = Skill.new
    @general_skill_param = params[:general_skill]
    @order_param = params[:order] || "score_asc"
    order_skills
  end

  def show

  end

  def new

  end

  def create
		@skill = Skill.new(skill_params)
    @skill.user = @current_user

		respond_to do |format|
			if @skill.save
        format.html { render :index }
        format.json { render :index, status: :created, location: @skill }
        format.js { @status = "success"}
      else
        format.html { render :index }
        format.json { render json: @skill.errors, status: :unprocessable_entity }
        format.js { @status = "fail" }
      end
    end
  end

  def edit

  end

  def update
    respond_to do |format|
			if @skill.update(skill_params)
        format.html { render :index }
        format.json { render :index, status: :created, location: @skill }
        format.js { @status = "success"}
      else
        format.html { render :index }
        format.json { render json: @skill.errors, status: :unprocessable_entity }
        format.js { @status = "fail" }
      end
    end
  end

  def destroy
		respond_to do |format|
			if @skill.destroy
        format.html { render :index }
        format.js { @status = "success"}
      else
        format.html { render :index }
        format.js { @status = "fail" }
      end
    end
  end

  def search
    @general_skill_param = params[:general_skill]
    @order_param = params[:order]
    order_skills
  end

  private
  def skill_params
    params.require(:skill).permit(:name, :general_skill_id)
  end

  def set_skill
    @skill = Skill.find(params[:id])
  end

  def set_options
    @general_skill_options = @current_user.general_skills.pluck(:name, :id)
    @order_options = [["↑総スコア", "score_asc"], ["↓総スコア", "score_desc"], ["↑Card数", "num_asc"], ["↓Card数", "num_desc"]]
  end

  def order_skills
    @skills = order_by_total_score_of_cards(@general_skill_param, @order_param) if @order_param.include?("score")
    @skills = order_by_total_num_of_cards(@general_skill_param, @order_param) if @order_param.include?("num")
  end

  def order_by_total_score_of_cards(gs, sort)
    if sort.include?("desc")
      Skill.of_current_user(@current_user).of_general_skill(gs).order_desc_by_total_score_of_cards.page(params[:page]).per(PER)
    else
      Skill.of_current_user(@current_user).of_general_skill(gs).order_asc_by_total_score_of_cards.page(params[:page]).per(PER)
    end
  end

  def order_by_total_num_of_cards(gs, sort)
    if sort.include?("desc")
      Skill.of_current_user(@current_user).of_general_skill(gs).order_desc_by_total_num_of_cards.page(params[:page]).per(PER)
    else
      Skill.of_current_user(@current_user).of_general_skill(gs).order_asc_by_total_num_of_cards.page(params[:page]).per(PER)
    end
  end
end
