class SkillsController < ApplicationController
  before_action :set_skill, only: [:edit, :update, :destroy]
  before_action :set_options, only: [:index, :edit]

  PER = 20

  def index
    @skill = Skill.new
    @skills = Skill.of_current_user(@current_user).order(id: "DESC").page(params[:page]).per(PER)
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

  private
  def skill_params
    params.require(:skill).permit(:name, :general_skill_id)
  end

  def set_skill
    @skill = Skill.find(params[:id])
  end

  def set_options
    @general_skill_options = @current_user.general_skills.pluck(:name, :id)
  end
end
