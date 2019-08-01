class GeneralSkillsController < ApplicationController
  before_action :set_general_skill, only: [:edit, :update, :destroy]

  def index
    @general_skill = GeneralSkill.new
    @general_skills = GeneralSkill.of_current_user(@current_user).order(id: "DESC")
  end

  def show

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

  private
  def general_skill_params
    params.require(:general_skill).permit(:name)
  end

  def set_general_skill
    @general_skill = GeneralSkill.find(params[:id])
  end
end
