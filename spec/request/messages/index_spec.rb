require 'rails_helper'

describe 'GET #index messages', type: :request do
  include_context 'conversation_between_two_users'

  let!(:messages) do
    create_list(:message, 2, user: user, conversation: conversation)
  end

  before { Pagy::VARS[:items] = 2 }

  subject do
    get api_v1_conversation_messages_path(
      conversation_id: conversation.id,
      page: page
    ), headers: auth_headers,
       as: :json
  end

  context 'when pagination every 2 messages' do
    context 'when getting first page' do
      let!(:page) { 1 }

      it 'returns 2 messages per page' do
        subject
        expect(parsed_data['messages'].count).to eq(2)
      end

      it 'returns oredered by id desc' do
        subject
        expect(parsed_data['messages'].first['id']).to eq(Message.last.id)
      end
    end

    context 'when getting second page' do
      let!(:page) { 2 }

      it 'returns 1 message' do
        subject
        expect(parsed_data['messages'].count).to eq(1)
      end

      it 'returns the earliest message the last' do
        subject
        expect(parsed_data['messages'].last['text'])
          .to eq('You have a new match!')
      end
    end
  end
end
