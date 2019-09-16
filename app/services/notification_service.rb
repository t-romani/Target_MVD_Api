class NotificationService
  attr_accessor :user, :matching_users, :text
  ONE_SIGNAL_APP_ID = ENV['ONE_SIGNAL_APP_ID']

  def initialize(user, matching_users = nil, text = nil)
    @user = user
    @matching_users = matching_users
    @text = text
  end

  def notify
    return if matching_users.nil?

    notify_users
  end

  def set_id
    return if user.player_id.present?

    uri = URI.parse(ENV['ONE_SIGNAL_ID_URL'])
    params = email_create_params(email_auth_hash)
    response = send_request(uri, params)
    update_player_id(response)
  end

  def notify_users
    player_ids = matching_users.map(&:player_id)

    uri = URI.parse(ENV['ONE_SIGNAL_NOTIFY_URL'])
    params = if text.present?
               msg_request_params(player_ids, text)
             else
               target_match_request_params(player_ids)
             end
    send_request(uri, params)
  end

  private

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
      app_id: ONE_SIGNAL_APP_ID,
      identifier: user.email,
      email_auth_hash: email_auth_hash
    }
  end

  def update_player_id(response)
    email_player_id = JSON.parse(response.body)['id']
    user.update!(player_id: email_player_id)
  end

  def target_match_request_params(player_ids)
    {
      app_id: ONE_SIGNAL_APP_ID,
      email_subject: I18n.t('api.email.matched_target.subject'),
      email_body: I18n.t('api.email.matched_target.body'),
      include_player_ids: player_ids
    }
  end

  def msg_request_params(player_ids, text)
    { 'app_id' => ONE_SIGNAL_APP_ID,
      'email_subject' => I18n.t('api.email.new_message.subject'),
      'email_body' => text,
      'include_player_ids' => player_ids }
  end

  def send_request(uri, params)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post
              .new(uri.path,
                   'Content-Type': 'application/json;charset=utf-8',
                   'Authorization': "Basic #{ENV['ONE_SIGNAL_API_KEY']}")
    request.body = params.as_json.to_json
    http.request(request)
  end
end
