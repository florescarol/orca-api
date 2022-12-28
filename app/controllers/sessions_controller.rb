class SessionsController < ApplicationController
  skip_before_action :authenticate_user!

  def create
    user = sign_in!

    render json: { message: "O login foi feito com sucesso.", remember_token: user.remember_token }, status: :ok
  rescue => e
    render json: { message: e.message }, status: :unauthorized
  end

  private

  def session_params
    params.permit(:username, :password)
  end

  def sign_in!
    uc = Authorization::UserSignIn.build
    uc.execute(
      username: session_params[:username],
      password: session_params[:password]
    )
  end

end
