require 'rails_helper'

describe 'GET #index conversation', type: :request do
  let!(:user)           { create(:user) }
  let!(:second_user)    { create(:user) }
  let!(:third_user)     { create(:user) }
  let!(:topic)          { create(:topic) }
  let!(:target_params)  { attributes_for(:target) }
  let!(:first_target) do
    create(:target, user: user, topic: topic,
                    latitude: target_params[:latitude],
                    longitude: target_params[:longitude])
  end
  let!(:second_target) do
    create(:target, user: second_user, topic: topic,
                    latitude: target_params[:latitude],
                    longitude: target_params[:longitude])
  end
  let!(:third_target) do
    create(:target, user: third_user, topic: topic,
                    latitude: target_params[:latitude],
                    longitude: target_params[:longitude])
  end

  subject do
    get api_v1_conversations_path, headers: auth_headers, as: :json
  end

  before { subject }

  context 'when valid' do
    let!(:auth_headers) { auth_user_headers }

    it 'returns a successfull answer' do
      expect(response).to be_successful
    end

    it 'returns the correct amount of conversations' do
      expect(parsed_data['conversations'].size)
        .to eq(user.conversations.count)
    end
  end

  context 'when invalid' do
    context 'when not logged in' do
      let!(:auth_headers) { {} }

      it 'returns unauthorized message' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns error' do
        expect(parsed_data['errors']).not_to be_empty
      end
    end
  end
end
