require 'rails_helper'

describe 'GET #index target', type: :request do  
  let!(:user)     { create(:user) }
  let!(:targets)  { create_list(:target, 2, user: user) }

  subject do
    get api_v1_targets_path, headers: auth_headers, as: :json
  end

  before { subject }

  context 'when valid' do
    let!(:auth_headers) { auth_user_headers }

    it 'gets a successfull answer' do
      expect(response).to be_successful
    end

    it 'returns the correct ids' do
      expect(parsed_data['targets'].pluck('id'))
        .to match_array(JSON.parse(targets.to_json).pluck('id'))
    end
  end

  context 'when invalid' do
    context 'when not logged in' do
      let!(:auth_headers) { {} }

      it 'shows unauthorized message' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns error' do
        expect(parsed_data['errors']).to eq(
          [
            'You need to sign in or sign up before continuing.'
          ]
        )
      end
    end
  end
end
