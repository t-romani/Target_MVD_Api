class MessageService
  attr_accessor :conversation

  def initialize(conversation)
    @conversation = conversation
  end

  def create_message(text, user)
    @message = conversation.messages
                           .create!(text: text, user_id: user.id,
                                    message_type: Message.message_types[:user])
    notify(text, user)
    @message
  end

  def notify(text, user)
    users = conversation.not_current_user(user)
    NotifyRequestJob.perform_later(user, users, text)
  end
end
