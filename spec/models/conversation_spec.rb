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
end
