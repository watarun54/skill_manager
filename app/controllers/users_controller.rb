class UsersController < ApplicationController
  skip_before_action :login_required, only: [:new, :create]
  before_action :redirect_login_user, only: [:new, :create]

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

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end