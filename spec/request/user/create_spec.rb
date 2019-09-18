require 'rails_helper'

describe 'POST #create sign_up', type: :request do
  let!(:user_params) { { user: attributes_for(:user) } }
  let(:user) { User.last }
  subject do
    post user_registration_path, params: user_params, as: :json
  end

  context 'when valid' do
    it 'does get a sucessful answer' do
      subject
      expect(response).to be_successful
    end

    it 'does create a new user' do
      expect { subject }.to change { User.count }.by(1)
    end

    it 'returns the user created' do
      subject
      expect(response.body).to include_json(
        user: {
          email: user.email,
          gender: user.gender,
          full_name: user.full_name
        }
      )
    end
  end

  context 'when invalid' do
    context 'when missing argument' do
      context '(email) it does not create a new user' do
        before do
          user_params[:user][:email] = nil
          subject
        end

        it 'does not create a new user' do
          expect(User.count).to eq(0)
        end

        it 'returns unprocessable_entity status' do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns error message' do
          data = JSON.parse(response.body)
          expect(data['errors']['full_messages'].first).to eq(
            'Email can\'t be blank'
          )
        end
      end

      context '(password)' do
        before do
          user_params[:user][:password] = nil
          subject
        end

        it 'does not create a new user' do
          expect(User.count).to eq(0)
        end

        it 'returns unprocessable_entity status' do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns error message' do
          data = JSON.parse(response.body)
          expect(data['errors']['full_messages'].first).to eq(
            'Password can\'t be blank'
          )
        end
      end

      context '(gender) it does not create a new user' do
        before do
          user_params[:user][:gender] = nil
          subject
        end

        it 'does not create a new user' do
          expect(User.count).to eq(0)
        end

        it 'returns unprocessable_entity status' do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns error message' do
          data = JSON.parse(response.body)
          expect(data['errors']['full_messages'].first).to eq(
            'Gender can\'t be blank'
          )
        end
      end
      context '(full_name) it does not create a new user' do
        before do
          user_params[:user][:full_name] = nil
          subject
        end

        it 'does not create a new user' do
          expect(User.count).to eq(0)
        end

        it 'returns unprocessable_entity status' do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns error message' do
          data = JSON.parse(response.body)
          expect(data['errors']['full_messages'].first).to eq(
            'Full name can\'t be blank'
          )
        end
      end
    end

    context 'when invalid password' do
      context '(different)' do
        before do
          user_params[:user][:password_confirmation] = 'different'
          subject
        end

        it 'does not create a new user' do
          expect(User.count).to eq(0)
        end

        it 'return unprocessable_entity status' do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns error message' do
          data = JSON.parse(response.body)
          expect(data['errors']['full_messages'].first).to eq(
            'Password confirmation doesn\'t match Password'
          )
        end
      end

      context '(short)' do
        before do
          user_params[:user][:password] = 'short'
          user_params[:user][:password_confirmation] = 'short'
          subject
        end

        it 'does not create a new user' do
          expect(User.count).to eq(0)
        end

        it 'return unprocessable_entity status' do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns error message' do
          data = JSON.parse(response.body)
          expect(data['errors']['full_messages'].first).to eq(
            'Password is too short (minimum is 6 characters)'
          )
        end
      end
    end
  end
end
