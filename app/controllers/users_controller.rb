class UsersController < ApplicationController
  skip_before_action :login_required, only: [:new, :create]
  before_action :redirect_login_user, only: [:new, :create]
  before_action :set_user, only: [:edit, :update, :destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    @user.email.downcase!

    if @user.save
      flash[:notice] = "Account created successfully!"
      redirect_to login_path
    else
      render "new"
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "Account updated successfully!"
      redirect_to edit_user_path(@user.id)
    else
      render "edit"
    end
  end

  def destroy
    if @user.destroy
      flash[:notice] = "Account deleted successfully!"
      redirect_to login_path
    else
      render "edit"
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
