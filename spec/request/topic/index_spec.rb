require 'rails_helper'

describe 'GET #index topic', type: :request do
  let!(:topics) { create_list(:topic, 2) }
  let(:data)    { parsed_data }

  subject do
    get api_v1_topics_path, headers: auth_headers, as: :json
  end

  before { subject }

  context 'when valid' do
    let!(:user)         { create(:user) }
    let!(:auth_headers) { auth_user_headers }

    it 'gets a successfull answer' do
      expect(response).to be_successful
    end

    it 'returns list of topics' do
      expect(data['topics'].count).to eq(topics.count)
    end
  end

  context 'when invalid' do
    context 'when not logged in' do
      let!(:auth_headers) { {} }

      it 'shows unauthorized message' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns error' do
        expect(data['errors']).to eq(
          [
            'You need to sign in or sign up before continuing.'
          ]
        )
      end
    end
  end
end
