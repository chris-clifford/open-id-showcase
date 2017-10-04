class SessionController < ApplicationController
  BaseURL = "http://localhost:3002"
  def index
    @token = nil
    if params[:code] && params[:state] == session[:state]
      auth_request_uri = "#{BaseURL}/oauth/token?" +
                        "client_id=584e229b9bfa46a2b79d055d907eb1d94f38c4a31b8d1f57aef32bb21091272c&" +
                        "client_secret=ef3055aa00eb757085b3d18894dd760dc56c927839a6a0a8f125c9c979f4f2cd&" +
                        "code=#{params[:code]}&redirect_uri=http://localhost:3000/&grant_type=authorization_code&scope=openid"
      request = HTTParty.post(auth_request_uri)

      if request['id_token']
        session[:id_token] = request['id_token']
      end
      if session[:id_token]
        split_token = session[:id_token].split('.')
        @payload = JSON.parse(Base64.decode64(split_token[1]))
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
    @code_request_uri = "#{BaseURL}/oauth/authorize?response_type=code&" +
                        "client_id=584e229b9bfa46a2b79d055d907eb1d94f38c4a31b8d1f57aef32bb21091272c&" +
                        "client_secret=ef3055aa00eb757085b3d18894dd760dc56c927839a6a0a8f125c9c979f4f2cd&" +
                        "redirect_uri=http://localhost:3000/&scope=openid&state=#{state}"
  end

  def create
    token = {header: {}, payload: {'iss': 'www.acceptto.com', sub: params[:email], exp: Time.now.to_i, iat: Time.now.to_i}}
    @payload = token[:payload].with_indifferent_access
    render :index
  end

  def delete
    reset_session
    redirect_to root_path
  end

  private

  def code_params
    params.permit(:code, :state, :username, :email, :password)
  end
end
