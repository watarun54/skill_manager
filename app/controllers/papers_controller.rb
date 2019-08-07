class PapersController < ApplicationController
  before_action :set_paper, only: [:edit, :update, :destroy]
  before_action :set_options, only: [:index, :edit]

  def index
    @paper = Paper.new
    @papers = Paper.of_current_user(@current_user).order(id: "DESC")
  end

  def show

  end

  def new

  end

  def create
		@paper = Paper.new(paper_params)
    @paper.user = @current_user
    @paper.title = "... タイトル取得中 ..."
    @paper.status ||= PAPER_STATUS_PENDING
    @paper.url.gsub!(" ", "")

		respond_to do |format|
			if @paper.save
        UpdatePapersJob.perform_later(@current_user.id, "", @paper.url)
        format.html { render :index }
        format.json { render :index, status: :created, location: @paper }
        format.js { @status = "success"}
      else
        format.html { render :index }
        format.json { render json: @paper.errors, status: :unprocessable_entity }
        format.js { @status = "fail" }
      end
    end
  end

  def edit

  end

  def update
    respond_to do |format|
			if @paper.update(paper_params)
        format.html { render :index }
        format.json { render :index, status: :created, location: @paper }
        format.js { @status = "success"}
      else
        format.html { render :index }
        format.json { render json: @paper.errors, status: :unprocessable_entity }
        format.js { @status = "fail" }
      end
    end
  end

  def destroy
		respond_to do |format|
			if @paper.destroy
        format.html { render :index }
        format.js { @status = "success"}
      else
        format.html { render :index }
        format.js { @status = "fail" }
      end
    end
  end

  private
  def paper_params
    params.require(:paper).permit(:title, :content, :status, :url, :general_skill_id)
  end

  def set_paper
    @paper = Paper.find(params[:id])
  end

  def set_options
    @general_skill_options = @current_user.general_skills.pluck(:name, :id)
    @paper_status_options = [
        ["pending", PAPER_STATUS_PENDING],
        ["confirmed", PAPER_STATUS_CONFIRMED],
        ["done", PAPER_STATUS_DONE]
      ]
  end
end
