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

  def self.create_conversations(matching_users)
    user = matching_users.pop
    matching_users.each do |match|
      conversation = share_conversation(user, match)
      if conversation.blank?
        conversation = Conversation.create!
        user.conversations << conversation
        match.conversations << conversation
      end
      conversation.messages.create!(
        text: I18n.t('api.messages.target_match')
      )
    end
  end

  def self.share_conversation(user, match)
    user_conversations = user.conversations
    match_conversations = match.conversations
    return if user_conversations.empty? || match_conversations.empty?

    user_conversations.each do |conv|
      return conv if match_conversations.include?(Conversation.find(conv.id))
    end

    nil
  end

  def not_current_user(current_user)
    users.where.not(id: current_user.id).to_a
  end
end
