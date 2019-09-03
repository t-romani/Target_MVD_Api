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
    it 'return ok status' do
      subject
      expect(response).to have_http_status(:ok)
    end

    it 'returns success message' do
      subject
      expect(parsed_data['success']).to eq(true)
    end
  end

  context 'when invalid' do
    let!(:auth_headers) { {} }

    it 'return unauthorized status' do
      subject
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns success false message' do
      subject
      expect(parsed_data['success']).to eq(false)
    end
  end
end
