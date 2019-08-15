require 'rails_helper'

RSpec.describe 'POST #create sign_in', type: :request do
  let!(:user_attrs) { { user: FactoryBot.attributes_for(:user) } }

  subject do
    post '/api/v1/users/sign_in', params: {
      email: user_attrs[:user][:email], password: user_attrs[:user][:password]
    }, as: :json
  end

  context 'when valid' do
    context 'when registered and confirmed' do
      let!(:user) { FactoryBot.create(:confirmed_user) }

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
      let!(:user) { FactoryBot.create(:user) }

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
      let!(:user) { FactoryBot.create(:confirmed_user) }

      it 'does not get a sucessful answer' do
        post '/api/v1/users/sign_in', params: {
          email: user_attrs[:user][:email], password: 'another'
        }, as: :json
        expect(response).not_to be_successful
      end

      it 'does not sign_in' do
        post '/api/v1/users/sign_in', params: {
          email: user_attrs[:user][:email], password: 'another'
        }, as: :json
        expect { response }.not_to(change { User.last.current_sign_in_at })
      end
    end
  end
end
