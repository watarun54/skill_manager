class ListsController < ApplicationController
  before_action :set_list, only: [:show, :edit, :update, :destroy]

  PER = 20

  def index
    @list = List.new
    @lists = @current_user.lists.order(id: "DESC").page(params[:page]).per(PER)
  end

  def show
    # @cards = Card.of_current_user(@current_user).where(list_id: params[:id]).rank(:row_order)
    @cards = Card.where(list_id: params[:id]).rank(:row_order)
  end

  def new

  end

  def new_card
    @card = Card.new
  end

  def create_card
    @card = Card.new(card_params)
    @card.status = "ready"
    @card.skill_id = @current_user.skills.first.try(:id)
    @card.list_id = params[:id]

    @card.save!
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

  def card_params
    params.require(:card).permit(:list_id, :skill_id, :score, :fact)
  end

  def set_list
    @list = List.find(params[:id])
  end
end
