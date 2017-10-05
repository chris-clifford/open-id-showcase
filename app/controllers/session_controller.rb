class SessionController < ApplicationController
  include SessionHelper
  def index
    if params[:code] && params[:state] == session[:state]
      auth_request_uri = get_auth_request_url(params[:code])
      request = HTTParty.post(auth_request_uri)

      session[:id_token] = request['id_token'] if request['id_token']

      if session[:id_token]
        split_token = session[:id_token].split('.')
        @payload = JSON.parse(Base64.decode64(split_token[1]))
      end

      @user = User.find_or_create_by(email: @payload["sub"])

    elsif params[:code]
      redirect_to login_path, alert: 'State value does not match'
    else
      redirect_to login_path
    end
  end

  def new
    state = SecureRandom.hex(30)
    session[:state] = state
    @code_request_uri = get_code_requesrt_url(state)
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      token = {header: {}, payload: {'iss': 'www.acceptto.com', sub: params[:email], exp: Time.now.to_i, iat: Time.now.to_i}}
      @payload = token[:payload].with_indifferent_access
      redirect_to '/'
    else
      flash[:alert] = "There was a problem signing up."
      redirect_to '/login'
    end
  end

  def destroy
    reset_session
    flash[:notice] = "You've signed out."
    redirect_to '/'
  end

  private

  def code_params
    params.permit(:code, :state, :username, :email, :password)
  end

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
end
