require 'rails_helper'
require 'support/shared_context/conversation_between_two_users.rb'

describe 'POST #create message', type: :request do
  include_context 'conversation_between_two_users'

  subject do
    post api_v1_conversation_messages_path(
      conversation_id: conversation.id
    ), params: message_params,
       headers: auth_headers,
       as: :json
  end

  context 'when valid' do
    let!(:message_params) { { message: attributes_for(:message) } }

    it 'does get a sucessful answer' do
      subject
      expect(response).to be_successful
    end

    it 'does create a new message to the conversation' do
      expect { subject }.to(change { conversation.messages.count }.by(1))
    end

    it 'does belong to the user' do
      subject
      expect(Message.last.user).to eq(user)
    end

    it 'does enqueue notify job' do
      ActiveJob::Base.queue_adapter = :test
      subject
      expect(NotifyRequestJob).to have_been_enqueued
    end

    context 'when unread messages on the other user conversation' do
      it 'returns correct amount of unread messages on conversation' do
        get api_v1_conversations_path, headers: another_auth_user_headers, as: :json
        expect(parsed_data['conversations'].first['unread_messages'])
          .to eq(0)
        subject
        expect(ConversationUser.find_by(user_id: another_user.id,
                                        conversation_id: conversation.id)
                               .unread_messages).to eq(1)
      end
    end
  end
end
