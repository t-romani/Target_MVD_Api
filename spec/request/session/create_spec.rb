require 'rails_helper'

describe 'POST #create sign_in', type: :request do
  subject do
    post user_session_path, params: {
      email: user[:email], password: password
    }, as: :json
  end

  context 'when valid' do
    let(:password) { 'example' }

    before do
      WebMock.stub_request(:post, 'https://onesignal.com/api/v1/players')
             .to_return(status: 200,
                        body: File.new(
                          'spec/support/fixtures/new_player_id_success.json'
                        ))
    end

    context 'when registered, confirmed and logging for the first time' do
      let!(:user) { create(:user, password: password, player_id: nil) }

      it 'does get a sucessful answer' do
        subject
        expect(response).to be_successful
      end

      it 'does create a new session' do
        subject
        expect(response.headers['client']).to eq(User.last.tokens.keys.first)
      end

      it 'does create a new player id' do
        expect { subject }.to(change { User.last.player_id })
      end
    end

    context 'when logging in with facebook' do
      let!(:facebook_params) { { access_token: '123456', format: :json } }

      subject { post facebook_api_v1_users_path, params: facebook_params, as: :json }

      before do
        post facebook_api_v1_users_path, params: facebook_params, as: :json
        User.last.update!(tokens: nil)
      end

      it 'returns a successful response' do
        subject
        expect(response).to be_successful
      end

      it 'does not create an user' do
        expect { subject }.not_to change(User, :count)
      end

      it 'creates new token' do
        expect { subject }.to change { User.last.tokens }
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
