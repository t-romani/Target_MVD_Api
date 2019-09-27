# == Schema Information
#
# Table name: messages
#
#  id              :bigint           not null, primary key
#  message_type    :integer          default("match"), not null
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
  enum message_type: { match: 0, user: 1 }

  belongs_to :user, optional: true
  belongs_to :conversation

  validates :text, :message_type, presence: true

  scope :order_desc, -> { order(id: :desc) }

  after_create :increment_unread

  private

  def increment_unread
    return if match?

    conversation.new_message(user.id)
  end
end
