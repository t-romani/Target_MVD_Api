class PlayerIdsService
  attr_accessor :user

  def initialize(user)
    @user = user
  end

  def register_for_notification
    return unless user.player_id.nil?

    uri = URI.parse(ENV['ONE_SIGNAL_ID_URL'].to_s)
    send_request(uri)
  end

  private

  def send_request(uri)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post
              .new(uri.path,
                   'Content-Type': 'application/json;charset=utf-8',
                   'Authorization': "Basic #{ENV['ONE_SIGNAL_API_KEY']}")
    request.body = email_create_params(email_auth_hash).as_json.to_json
    update_player_id(http.request(request))
  end

  def email_auth_hash
    OpenSSL::HMAC.hexdigest(
      'sha256',
      ENV['ONE_SIGNAL_API_KEY'],
      user.email
    )
  end

  def email_create_params(email_auth_hash)
    {
      device_type: 11,
      app_id: ENV['ONE_SIGNAL_APP_ID'],
      identifier: user.email,
      email_auth_hash: email_auth_hash
    }
  end

  def update_player_id(response)
    email_player_id = JSON.parse(response.body)['id']
    user.player_id = email_player_id
    user.save!
  end
end
