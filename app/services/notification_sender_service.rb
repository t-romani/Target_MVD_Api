# OneSignal::OneSignal.user_auth_key = ENV['USER_AUTH_KEY']
# OneSignal::OneSignal.api_key = ENV['API_KEY']
class NotificationSenderService
  def send_notification(matched_users)
    external_user_ids = matched_users.collect { |u| u.values_at('player_id') }
    OneSignal::Notification.create(
      params: {
        "app_id": ENV['APP_ID'],
        "include_external_user_ids": external_user_ids,
        "contents": {
          "en": "You have matched another target!"
        }
      },
      opts: {
        "api_key": ENV['API_KEY']
      }
    )
  end

  def session_update(current_user)
    @user = current_user
    new_user if @user.player_id.nil?
    updater
  end

  private

  def new_user
    r = OneSignal::Player.create(
      params: {
        "app_id": ENV['APP_ID'],
        "device_type": 0
      }
    )
    data = JSON.parse(r.body)
    @user.player_id = data['id']
    @user.save
  end

  def updater
    player_id = @user.player_id
    OneSignal::Player.update(
      id: player_id,
      params: {
        "app_id": ENV['APP_ID'],
        "device_type": 0
      }
    )
  end
end
