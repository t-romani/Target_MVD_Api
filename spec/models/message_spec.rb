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

require 'rails_helper'
require 'support/shared_context/conversation_between_two_users.rb'

describe Message, type: :model do
  include_context 'conversation_between_two_users'

  subject do
    build(:message, user: user, conversation: conversation)
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:text) }
    it { is_expected.to belong_to(:conversation) }
  end
end
