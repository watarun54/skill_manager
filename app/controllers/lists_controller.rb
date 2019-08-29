class ListsController < ApplicationController
  before_action :set_list, only: [:show, :edit, :update, :destroy]

  PER = 20

  def index
    @list = List.new
    @lists = @current_user.lists.order(id: "DESC").page(params[:page]).per(PER)
  end

  def show

  end

  def new

  end

  def create
		@list = List.new(list_params)
    @list.user_id = @current_user.id

		respond_to do |format|
			if @list.save
        format.html { render :index }
        format.json { render :index, status: :created, location: @list }
        format.js { @status = "success"}
      else
        format.html { render :index }
        format.json { render json: @list.errors, status: :unprocessable_entity }
        format.js { @status = "fail" }
      end
    end
  end

  def edit

  end

  def update
    respond_to do |format|
			if @list.update(list_params)
        format.html { render :index }
        format.json { render :index, status: :created, location: @list }
        format.js { @status = "success"}
      else
        format.html { render :index }
        format.json { render json: @list.errors, status: :unprocessable_entity }
        format.js { @status = "fail" }
      end
    end
  end

  def destroy
		respond_to do |format|
			if @list.destroy
        format.html { render :index }
        format.js { @status = "success"}
      else
        format.html { render :index }
        format.js { @status = "fail" }
      end
    end
  end

  private

  def list_params
    params.require(:list).permit(:name)
  end

  def set_list
    @list = List.find(params[:id])
  end
end
