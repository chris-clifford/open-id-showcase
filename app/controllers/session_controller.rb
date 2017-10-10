class SessionController < ApplicationController
  include SessionHelper
  def index
    if current_user && session[:id_token]
      @payload = session[:id_token]
      return render :index
    end

    if params[:code] && params[:state] == session[:state]
      request = HTTParty.post(get_auth_request_url(params[:code]))

      if request['id_token']
        verified_token = verify_token(request['id_token'])
        @payload = verified_token[0]
        session[:id_token] = verified_token[0]
        @user = User.find_or_create_by(email: @payload["sub"])
        session[:user_id] = @user.id
      else
        redirect_to login_path, alert: 'There was an error getting your login information from Acceptto'
      end

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
      token = {'iss': 'www.acceptto.com', sub: @user.email, exp: Time.now.to_i, iat: Time.now.to_i, new: true}
      session[:id_token] = token
      @payload = session[:id_token].with_indifferent_access
      render :index
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
