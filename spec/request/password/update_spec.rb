require 'rails_helper'

describe 'PUT #update password', type: :request do
  let!(:user)         { create(:user) }
  let!(:auth_headers) { auth_user_headers }
  let!(:new_password) { Faker::Internet.password }

  subject do
    put user_password_path, params: {
      password: new_password,
      password_confirmation: new_password
    }, headers: auth_headers, as: :json
  end

  context 'when valid' do
    it 'returns ok status' do
      subject
      expect(response).to be_successful
    end

    it 'returns correct user' do
      subject
      expect(parsed_data['user']['id']).to eq(user.id)
    end
  end

  context 'when invalid' do
    let!(:auth_headers) { {} }

    it 'returns unauthorized status' do
      subject
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns success false message' do
      subject
      expect(parsed_data['success']).to eq(false)
    end
  end
end
