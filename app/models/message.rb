# == Schema Information
#
# Table name: messages
#
#  id              :bigint           not null, primary key
#  text            :text             not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  conversation_id :bigint           not null
#  user_id         :bigint
#
# Indexes
#
#  index_messages_on_conversation_id  (conversation_id)
#  index_messages_on_user_id          (user_id)
#

class Message < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :conversation

  validates :text, presence: true
end
