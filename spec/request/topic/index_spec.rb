require 'rails_helper'

describe 'GET #index topic', type: :request do
  let!(:topic1) { create(:topic) }
  let!(:topic2) { create(:topic) }
  let(:topics)  { Topic.all }

  subject do
    get api_v1_topics_path, headers: auth_headers, as: :json
  end

  before do
    subject
  end

  context 'when valid' do
    context 'when logged in' do
      let!(:user)         { create(:user) }
      let!(:auth_headers) { auth_user_headers }

      it 'gets a successfull answer' do
        expect(response).to be_successful
      end

      it 'returns list of topics' do
        data = JSON.parse(response.body)
        expect(data['topics'].count).to eq(topics.count)
      end
    end
  end

  context 'when invalid' do
    context 'when not logged in' do
      let!(:auth_headers) { {} }

      it 'shows unauthorized message' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns error' do
        data = JSON.parse(response.body)
        expect(data['errors']).to eq(
          [
            'You need to sign in or sign up before continuing.'
          ]
        )
      end
    end
  end
end
