class ListElementsController < ApplicationController
  before_action :set_list_element, only: [:edit, :update, :destroy, :new_card, :create_card]

  def new
    @list = List.find(params[:list_id])
    @le = ListElement.new
  end

  def create
    @le = ListElement.new(le_params)
    @le.save!
    redirect_to controller: "lists", action: "show", id: @le.list.id
  end

  def edit

  end

  def update
    @le.update!(le_params)
    redirect_to controller: "lists", action: "show", id: @le.list.id
  end

  def destroy
    list_id = @le.list.id
    @le.destroy
    redirect_to controller: "lists", action: "show", id: list_id
  end

  def new_card
    @card = Card.new
    @skill_options = @current_user.skills.pluck(:name, :id)
    @score_options = CardConstants::SCORE_OPTIONS
  end

  def create_card
    @card = Card.new(card_params)
    @card.skill_id = @current_user.skills.first.try(:id)
    @card.list_element_id = params[:id]

    @card.save!
  end

  def change_le
    @card = Card.find(params["card_id"])
    le = ListElement.find(params["to_le_id"])
    min_row_order = le.cards.minimum(:row_order)
    new_row_order = min_row_order.nil? ? 100 : min_row_order - 100
    @card.update!(row_order: new_row_order, list_element_id: le.id)
  end

  def sort
    le = ListElement.find(params[:list_element_id])
    le.update(le_params)
    render body: nil
  end

  private

  def le_params
    params.require(:list_element).permit(:name, :list_id, :row_order_position)
  end

  def card_params
    params.require(:card).permit(:list_id, :skill_id, :score, :fact)
  end

  def set_list_element
    @le = ListElement.find(params[:id])
  end
end
