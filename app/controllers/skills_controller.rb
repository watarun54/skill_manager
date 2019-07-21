class SkillsController < ApplicationController
  def index
    @skill ||= Skill.new
    @skills = Skill.all.order(id: "DESC")
  end

  def show

  end

  def new

  end

  def create
		@skill = Skill.new(skill_params)

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

  end

  def destroy

  end

  private
  def skill_params
    params.require(:skill).permit(:name)
  end

  def set_skill
    @skill = Skill.find(params[:id])
  end
end
