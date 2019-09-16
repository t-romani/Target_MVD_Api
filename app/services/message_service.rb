class MessageService
  attr_accessor :conversation

  def initialize(conversation)
    @conversation = conversation
  end

  def create_message(text, user)
    @message = conversation.messages
                           .create!(text: text, user_id: user.id)
    notify(text, user)
    @message
  end

  def notify(text, user)
    return if target_match(text)

    users = conversation.not_current_user(user)
    NotifyRequestJob.perform_later(user, users, text)
  end

  private

  def target_match(text)
    text == I18n.t('api.messages.target_match')
  end
end
