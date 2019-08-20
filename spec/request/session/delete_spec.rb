require 'rails_helper'

describe 'POST #delete sign_out', type: :request do
  let!(:user_attrs)     { { user: attributes_for(:user) } }
  let!(:user)           { create(:user, :confirmed) }

  subject do
    delete destroy_user_session_path, headers: auth_headers, as: :json
  end

  context 'when valid' do
    context 'when signed in' do
      let!(:auth_headers) { auth_user_headers }

      it 'gets a sucessful answer' do
        subject
        expect(response).to be_successful
      end

      it 'does sign out' do
        expect { subject }.to change { User.last.tokens.size }.by(-1)
      end
    end
  end

  context 'when invalid' do
    context 'when not signed in' do
      let!(:auth_headers) { {} }
      it 'gets a not found error' do
        subject
        expect(response).to have_http_status(404)
      end

      it 'does not modify tokens' do
        expect { subject }.not_to change(User.last.tokens, :size)
      end
    end
  end
end
