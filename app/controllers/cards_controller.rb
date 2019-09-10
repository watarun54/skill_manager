class CardsController < ApplicationController
  before_action :set_card_info, only: [:edit, :update, :destroy]
  before_action :set_options, only: [:list, :new, :edit, :search]
  before_action :set_skill_options_hash, only: [:list, :new, :edit, :search]

  PER = 18

  def list
    @general_skill_param = params[:general_skill]
    @skill_param = params[:skill]
    @cards = order_cards
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
        format.html { render :list }
        format.js { @status = "success"}
      else
        format.html { render :list }
        format.js { @status = "fail" }
      end
    end
  end

  def search
    @general_skill_param = params[:general_skill]
    @skill_param = skill_has_gs?(params[:skill], params[:general_skill]) ? params[:skill] : nil
    @cards = order_cards
  end

  private
  def card_params
    params.require(:card).permit(:skill_id, :score, :fact)
  end

  def set_card_info
    @card = Card.find(params[:id])
  end

  def set_options
    @general_skill_options = @current_user.general_skills.pluck(:name, :id)
    @skill_options = @current_user.skills.pluck(:name, :id)
    @score_options = CardConstants::SCORE_OPTIONS
  end

  def set_skill_options_hash
    @skill_options_hash = {}
    @current_user.general_skills.includes(:skills).each do |gs|
      @skill_options_hash[gs.id.to_s] = gs.skills.pluck(:name, :id).unshift(["All", nil])
    end
  end

  def order_cards
    if @general_skill_param.blank?
      Card.of_current_user(@current_user).order(id: "DESC").page(params[:page]).per(PER)
    else
      Card.of_current_user(@current_user)
        .of_general_skill(GeneralSkill.find_by(id: @general_skill_param))
        .of_skill(@skill_param)
        .order(id: "DESC")
        .page(params[:page]).per(PER)
    end
  end

  def skill_has_gs?(skill_id, gs_id)
    Skill.find_by(id: skill_id, general_skill_id: gs_id)
  end
end
