class SkillsController < ApplicationController
  def index
    @skills = Skill.all.order(id: "DESC")
  end

  def show

  end

  def new

  end

  def create

  end

  def edit

  end

  def update

  end

  def destroy

  end
end
