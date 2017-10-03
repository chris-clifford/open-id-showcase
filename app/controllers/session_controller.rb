class SessionController < ApplicationController
  def index
    @token = nil
    if params[:code] && params[:state] == session[:state]
      auth_request_uri = "http://localhost:3002/oauth/token?" +
                        "client_id=584e229b9bfa46a2b79d055d907eb1d94f38c4a31b8d1f57aef32bb21091272c&" +
                        "client_secret=ef3055aa00eb757085b3d18894dd760dc56c927839a6a0a8f125c9c979f4f2cd&" +
                        "code=#{params[:code]}&redirect_uri=http://localhost:3000/&grant_type=authorization_code&scope=openid"
      request = HTTParty.post(auth_request_uri)
      if request['id_token']
        split_token = request['id_token'].split('.')
        @header = Base64.decode64(split_token[0])
        @payload = Base64.decode64(split_token[1])
        @signature = Base64.decode64(split_token[2])
      end
      
      render :index
    elsif params[:code]
      redirect_to root, alert: 'State value does not match'
    end
  end

  def new
    state = SecureRandom.hex(30)
    session[:state] = state
    @code_request_uri = "http://localhost:3002/oauth/authorize?response_type=code&" +
                        "client_id=584e229b9bfa46a2b79d055d907eb1d94f38c4a31b8d1f57aef32bb21091272c&" +
                        "client_secret=ef3055aa00eb757085b3d18894dd760dc56c927839a6a0a8f125c9c979f4f2cd&" +
                        "redirect_uri=http://localhost:3000/&scope=openid&state=#{state}"
  end

  private

  def code_params
    params.permit(:code, :state)
  end
end
