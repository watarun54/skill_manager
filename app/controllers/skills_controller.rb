class SkillsController < ApplicationController
  before_action :set_skill, only: [:edit, :update, :destroy]

  def index
    @skill = Skill.new
    @skills = @current_user.skills.order(id: "DESC")
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
				@msg = "success"
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
    params.require(:skill).permit(:name)
  end

  def set_skill
    @skill = Skill.find(params[:id])
  end
end
