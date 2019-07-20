class CardsController < ApplicationController
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

	def destroy
		@card = Card.find(params[:id])
		
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
end
