class ListElementsController < ApplicationController
  before_action :set_list_element, only: [:edit, :update, :destroy, :new_card, :create_card]

  def new
    @list = List.find(params[:list_id])
    @le = ListElement.new
  end

  def create
    @le = ListElement.new(le_params)

    respond_to do |format|
			if @le.save
        format.html { render :index }
        format.json { render :index, status: :created, location: @le }
        format.js { @status = "success"}
      else
        format.html { render :index }
        format.json { render json: @le.errors, status: :unprocessable_entity }
        format.js { @status = "fail" }
      end
    end
  end

  def edit

  end

  def update
    respond_to do |format|
			if @le.update(le_params)
        format.html { render :index }
        format.json { render :index, status: :created, location: @le }
        format.js { @status = "success"}
      else
        format.html { render :index }
        format.json { render json: @le.errors, status: :unprocessable_entity }
        format.js { @status = "fail" }
      end
    end
  end

  def destroy
    respond_to do |format|
			if @le.destroy
        format.html { render :index }
        format.js { @status = "success"}
      else
        format.html { render :index }
        format.js { @status = "fail" }
      end
    end
  end

  def new_card
    @card = Card.new
  end

  def create_card
    @card = Card.new(card_params)
    @card.skill_id = @current_user.skills.first.try(:id)
    @card.list_element_id = params[:id]

    @card.save!
  end

  private

  def le_params
    params.require(:list_element).permit(:name, :list_id)
  end

  def card_params
    params.require(:card).permit(:list_id, :skill_id, :score, :fact)
  end

  def set_list_element
    @le = ListElement.find(params[:id])
  end
end
