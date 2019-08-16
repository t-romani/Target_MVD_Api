require 'rails_helper'

describe 'POST #create sign_in', type: :request do
  let!(:user_attrs) { { user: attributes_for(:user) } }

  subject do
    post api_v1_user_session_path, params: {
      email: user_attrs[:user][:email], password: password
    }, as: :json
  end

  context 'when valid' do
    let(:password) { 'example' }
    context 'when registered and confirmed' do
      let!(:user) { create(:user, :confirmed, password: password) }

      it 'does get a sucessful answer' do
        subject
        expect(response).to be_successful
      end

      it 'does create a new session' do
        expect { subject }.to(change { User.last.current_sign_in_at })
      end
    end
  end

  context 'when invalid' do
    context 'when registered and not confirmed' do
      let(:password) { 'example' }
      let!(:user) { create(:user, password: password) }

      it 'does not get a sucessful answer' do
        subject
        expect(response).not_to be_successful
      end
      it 'does not sign_in' do
        subject
        expect { subject }.not_to(change { User.last.current_sign_in_at })
      end
    end

    context 'when registered and confirmed but invalid credentials' do
      let!(:user) { create(:confirmed_user) }
      let(:password) { 'another' }

      it 'does not get a sucessful answer' do
        subject
        expect(response).not_to be_successful
      end

      it 'does not sign_in' do
        subject
        expect { response }.not_to(change { User.last.current_sign_in_at })
      end
    end
  end
end
