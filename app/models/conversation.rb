# == Schema Information
#
# Table name: conversations
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Conversation < ApplicationRecord
  has_many :conversation_users, dependent: :destroy
  has_many :users, through: :conversation_users
  has_many :messages, dependent: :destroy

  scope :with_unread_messages_count_for, lambda { |user_id|
    select('conversations.*, conversation_users.unread_messages AS unread_count')
      .joins(:conversation_users)
      .where(conversation_users: { user_id: user_id })
  }

  def self.create_conversations(user, matching_users)
    matching_users.each do |match|
      conversation = share_conversation(user, match)
      if conversation.blank?
        conversation = Conversation.create!
        user.conversations << conversation
        match.conversations << conversation
      end
      conversation.messages.create!(
        text: I18n.t('api.messages.target_match'),
        message_type: Message.message_types[:match]
      )
    end
  end

  def self.share_conversation(user, match)
    user_conversations = user.conversations
    match_conversations = match.conversations
    return if user_conversations.empty? || match_conversations.empty?

    user_conversations.detect do |conv|
      match_conversations.include?(conv)
    end
  end

  def not_current_user(current_user)
    users.where.not(id: current_user.id).to_a
  end

  def new_message(user_id)
    conversations_with_new_messages = ConversationUser.not_for_user(user_id, id)
    conversations_with_new_messages.each do |conversation_user|
      conversation_user.update!(unread_messages:
          (conversation_user.unread_messages + 1))
    end
  end

  def read_messages(user_id)
    conversation_with_read_messages =
      conversation_users.find_by(user_id: user_id)
    conversation_with_read_messages.update!(unread_messages: 0)
  end
end
