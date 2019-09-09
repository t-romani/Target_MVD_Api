class NotifyRequestJob < ApplicationJob
  queue_as :default

  def perform(matching_users)
    NotificationService.new(matching_users).notify
  end
end
