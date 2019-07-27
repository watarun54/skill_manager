class SessionsController < ApplicationController
  skip_before_action :require_sign_in!, only: [:new, :create]
  before_action :set_user, only: [:create]

  def new
  end

  def create
    if @user.authenticate(session_params[:password])
      sign_in(@user)
      redirect_to root_path
    else
      flash.now[:alert] = t('.flash.invalid_password')
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to login_path
  end

  private

  def set_user
    @user = User.find_by(email: session_params[:email])
    if @user.nil?
      flash.now[:alert] = t('.flash.invalid_email')
      render action: 'new' and return
    end
  end

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
