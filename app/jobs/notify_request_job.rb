class NotifyRequestJob < ApplicationJob
  queue_as :default

  def perform(user, matching_users, text)
    NotificationService.new(user, matching_users, text).notify
  end
end
