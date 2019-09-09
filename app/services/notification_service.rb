class NotificationService
  attr_accessor :users

  def initialize(matching_users)
    @users = matching_users
  end

  def notify
    ids = users.map(&:player_id)
    params = request_params(ids)
    uri = URI.parse(ENV['ONE_SIGNAL_NOTIFY_URL'].to_s)
    send_request(uri, params)
  end

  private

  def request_params(ids)
    { 'app_id': ENV['ONE_SIGNAL_APP_ID'],
      'email_subject': I18n.t('api.email.matched_target.subject'),
      'email_body': I18n.t('api.email.matched_target.body'),
      'include_player_ids': ids }
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
