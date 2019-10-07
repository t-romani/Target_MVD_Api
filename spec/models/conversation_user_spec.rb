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

require 'rails_helper'

describe ConversationUser, type: :model do
  include_context 'conversation_between_two_users'

  subject { conversation_user }

  describe 'validations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:conversation) }
    it { is_expected.to validate_numericality_of(:unread_messages) }
  end
end
