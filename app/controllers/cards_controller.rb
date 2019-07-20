class CardsController < ApplicationController
  before_action :set_card_info, only: [:edit, :update, :destroy]

	def index
	end

	def list
		@cards = Card.all.order(id: "DESC")
	end

	def new
    @card = Card.new()
    @skill_set = Skill.all.pluck(:name, :id)
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
    @skill_set = Skill.all.pluck(:name, :id)
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
end
