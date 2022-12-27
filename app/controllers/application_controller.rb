class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  rescue_from ::InvalidAuthenticationTokenException, with: :handle_unauthorized_request

  before_action :authenticate_user!

  def authenticate_user!
    @current_user = get_current_user

    raise InvalidAuthenticationTokenException.new if @current_user.nil?
  end

  def get_current_user
    User.find_by(remember_token: remember_token) if remember_token
  end

  private

  def remember_token
    params[:session_token]
  end

  def handle_unauthorized_request
    render json: { message: "É preciso logar para realizar essa ação." }, status: :unauthorized
  end

end
