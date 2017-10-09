module SessionHelper
  BaseURL = Rails.configuration.url_parameters['base_url']
  ClientID = Rails.configuration.url_parameters['client_id']
  ClientSecret = Rails.configuration.url_parameters['client_secret']
  RedirectURL = Rails.configuration.url_parameters['redirect_url']
  PublicKey = Rails.configuration.url_parameters['public_key']
  def get_auth_request_url(code)
    "#{BaseURL}/oauth/token?client_id=#{ClientID}&client_secret=#{ClientSecret}&code=#{code}&redirect_uri=#{RedirectURL}&grant_type=authorization_code&scope=openid"
  end

  def get_code_requesrt_url(state)
    "#{BaseURL}/oauth/authorize?response_type=code&client_id=#{ClientID}&client_secret=#{ClientSecret}&redirect_uri=#{RedirectURL}&scope=openid&state=#{state}"
  end

  def verify_token(token)
    key = OpenSSL::PKey::RSA.new(PublicKey)
    begin
      decoded = JWT.decode(token, key, true, { :algorithm => 'RS256' })
    rescue JWT::VerificationError
      false
    end
  end
end
