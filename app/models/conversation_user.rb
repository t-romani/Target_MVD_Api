# == Schema Information
#
# Table name: conversation_users
#
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
end
