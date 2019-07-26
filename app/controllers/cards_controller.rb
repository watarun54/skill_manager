class CardsController < ApplicationController
  before_action :set_card_info, only: [:edit, :update, :destroy]
  before_action :set_options, only: [:new, :edit]

  PER = 18

	def list
		@cards = Card.all.order(id: "DESC").page(params[:page]).per(PER)
	end

	def new
    @card = Card.new()
	end

	def create
		@card = Card.new(card_params)

		respond_to do |format|
			if @card.save
        format.html { render :list }
        format.json { render :list, status: :created, location: @card }
        format.js { @status = "success"}
      else
        format.html { render :list }
        format.json { render json: @card.errors, status: :unprocessable_entity }
        format.js { @status = "fail" }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
			if @card.update(card_params)
        format.html { render :list }
        format.json { render :list, status: :created, location: @card }
        format.js { @status = "success"}
      else
        format.html { render :list }
        format.json { render json: @card.errors, status: :unprocessable_entity }
        format.js { @status = "fail" }
      end
    end
  end

	def destroy		
		respond_to do |format|
			if @card.destroy
				@msg = "success"	
        format.html { render :list }
        format.js { @status = "success"}
      else
        format.html { render :list }
        format.js { @status = "fail" }
      end
    end
  end

  private
  def card_params
    params.require(:card).permit(:skill_id, :score, :fact)
  end

  def set_card_info
    @card = Card.find(params[:id])
  end

  def set_options
    @skill_options = Skill.all.pluck(:name, :id)
    @score_options = CardConstants::SCORE_OPTIONS
  end
end
