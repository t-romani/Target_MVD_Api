# == Schema Information
#
# Table name: conversation_users
#
#  id              :bigint           not null, primary key
#  unread_messages :integer          default(0), not null
#  conversation_id :bigint           not null
#  user_id         :bigint           not null
#
# Indexes
#
#  index_conversation_users_on_conversation_id              (conversation_id)
#  index_conversation_users_on_user_id                      (user_id)
#  index_conversation_users_on_user_id_and_conversation_id  (user_id,conversation_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (conversation_id => conversations.id)
#  fk_rails_...  (user_id => users.id)
#

class ConversationUser < ApplicationRecord
  belongs_to :user
  belongs_to :conversation

  validates :unread_messages, numericality: { only_integer: true }

  scope :not_for_user, lambda { |user_id, conversation_id|
    where(conversation_id: conversation_id)
      .where.not(user_id: user_id)
  }
end
