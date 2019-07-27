class ApplicationController < ActionController::Base
  before_action :set_current_user, :login_required

  protect_from_forgery with: :exception

  class LoginRequired < StandardError; end
  class Forbidden < StandardError; end

  if Rails.env.production? || ENV["RESCUE_EXCEPTIONS"]
      rescue_from StandardError, with: :rescue_internal_server_error
      rescue_from ActiveRecord::RecordNotFound, with: :rescue_not_found
      rescue_from ActionController::ParameterMissing, with: :rescue_bad_request
  end

  rescue_from LoginRequired, with: :rescue_login_required
  rescue_from Forbidden, with: :rescue_forbidden

  def set_current_user
    remember_token = User.encrypt(cookies[:user_remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end

  private

  def login_required
    raise LoginRequired unless @current_user.present?
  end

  def rescue_bad_request(exception)
    render "errors/bad_request", status: 400, formats: [:html]
  end

  def rescue_login_required(exception)
    # render "errors/login_required", status: 403, formats: [:html]
    redirect_to :login
  end

  def rescue_forbidden(exception)
    render "errors/forbidden", status: 403, formats: [:html]
  end

  def rescue_not_found(exception)
    render "errors/not_found", status: 404, formats: [:html]
  end

  def rescue_internal_server_error(exception)
    render "errors/internal_server_error", status: 500, formats: [:html]
  end
end
