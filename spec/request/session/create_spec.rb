require 'rails_helper'

describe 'POST #create sign_in', type: :request do
  subject do
    post user_session_path, params: {
      email: user[:email], password: password
    }, as: :json
  end

  context 'when valid' do
    let(:password) { 'example' }
    context 'when registered and confirmed' do
      let!(:user) { create(:user, password: password) }

      it 'does get a sucessful answer' do
        subject
        expect(response).to be_successful
      end

      it 'does create a new session' do
        subject
        expect(response.headers['client']).to eq(User.last.tokens.keys.first)
      end
    end
  end

  context 'when invalid' do
    context 'when registered and not confirmed' do
      let(:password)  { 'example' }
      let!(:user)     { create(:user, password: password) }
      before do
        user.update(confirmed_at: nil)
      end

      it 'gets an unauthorized status' do
        subject
        expect(response).to have_http_status(:unauthorized)
      end

      it 'does not sign_in' do
        expect { subject }.not_to change(User.last.tokens, :size)
      end
    end

    context 'when registered and confirmed but invalid credentials' do
      let!(:user) { create(:user) }
      let(:password) { 'another' }

      it 'does not get a sucessful answer' do
        subject
        expect(response).to have_http_status(:unauthorized)
      end

      it 'does not sign_in' do
        expect { subject }.not_to change(User.last.tokens, :size)
      end
    end
  end
end
