require 'rails_helper'

RSpec.describe 'POST #create sign_up', type: :request do  
  let!(:user_params) { { user: FactoryBot.attributes_for(:user) } }
  subject do
    post '/api/v1/users', params: user_params, as: :json
  end

  context 'when valid' do
    it 'does get a sucessful answer' do
      subject
      expect(response).to be_successful
    end

    it 'does create a new user' do
      expect { subject }.to change { User.count }.by(1)
    end

    it 'the attributes from params persist on db' do
      subject
      expect(response.body).to include_json(
        user: {
          email: User.last.email,
          gender: User.last.gender,
          full_name: User.last.full_name
        }
      )
    end
  end

  context 'when invalid' do
    context 'when missing argument' do
      it '(email) it does not create a new user' do
        user_params[:user][:email] = nil
        subject
        expect(response).not_to be_successful
      end

      it '(password) it does not create a new user' do
        user_params[:user][:password] = nil
        subject
        expect(response).not_to be_successful
      end

      it '(gender) it does not create a new user' do
        user_params[:user][:gender] = nil
        subject
        expect(response).not_to be_successful
      end
      it '(full_name) it does not create a new user' do
        user_params[:user][:full_name] = nil
        subject
        expect(response).not_to be_successful
      end
    end

    context 'when invalid password' do
      it '(different) it does not create a new user' do
        user_params[:user][:password] = 'password'
        user_params[:user][:password] = 'different'
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it '(short) it does not create a new user' do
        user_params[:user][:password] = 'short'
        user_params[:user][:password] = 'short'
        subject
        expect(response).not_to be_successful
      end
    end
  end
end
