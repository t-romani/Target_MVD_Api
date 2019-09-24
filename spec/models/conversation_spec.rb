# == Schema Information
#
# Table name: conversations
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

describe Conversation, type: :model do
  let!(:user)            { create(:user) }
  let!(:second_user)     { create(:user) }

  subject { build(:conversation) }

  describe 'validations' do
    it { is_expected.to have_many(:conversation_users) }
    it { is_expected.to have_many(:users).through(:conversation_users) }
    it { is_expected.to have_many(:messages) }
  end

  describe '.create_conversations' do
    let!(:conversation) { create(:conversation) }

    subject(:create_conversations) do
      Conversation.create_conversations(user, [second_user])
    end

    it 'creates a conversation' do
      expect { subject }.to change { Conversation.count }.by(1)
    end

    it 'includes each user' do
      subject
      expect(Conversation.last).to eq(user.conversations.last)
      expect(Conversation.last).to eq(second_user.conversations.last)
    end
  end

  describe '.share_conversation' do
    context 'when created conversation' do
      let!(:conversation) { Conversation.create! }

      it 'returns the conversation' do
        conversation.users << user
        conversation.users << second_user
        expect(Conversation.share_conversation(user, second_user))
          .to eq(conversation)
      end
    end

    context 'when not created a conversation between the users' do
      it 'returns nil' do
        expect(Conversation.share_conversation(user, second_user)).to eq(nil)
      end
    end
  end

  describe '.with_unread_messages_count_for' do
    include_context 'conversation_between_two_users'

    subject { Conversation.with_unread_messages_count_for(user.id) }

    it 'returns the conversations for the user' do
      expect(subject.size).to eq(user.conversations.size)
    end

    it 'returns 0 unread messages for the conversation' do
      expect(subject.find(conversation.id).unread_count).to eq(0)
    end
  end

  describe '#new_message' do
    include_context 'conversation_between_two_users'

    subject do
      conversation.new_message(another_user.id)
    end

    it 'increments unread messages' do
      expect { subject }.to change {
        conversation_user.reload.unread_messages
      }.by(1)
    end
  end

  describe '#read_messages' do
    include_context 'conversation_between_two_users'

    subject do
      conversation.read_messages(user.id)
    end

    before do
      conversation.new_message(another_user.id)
      conversation.new_message(another_user.id)
    end

    it 'sets unread messages value to 0' do
      expect { subject }.to change {
        conversation_user.reload.unread_messages
      }.by(-2)
    end
  end
end
