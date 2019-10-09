class FacebookService
  def initialize(access_token)
    @access_token = access_token
  end

  def profile
    client.get_object('me?fields=email,first_name,gender,last_name,picture')
  end

  def client
    Koala::Facebook::API.new(@access_token, ENV['FACEBOOK_APP_SECRET'])
  end
end
