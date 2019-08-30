require 'rails_helper'

describe 'POST #create target', type: :request do
  let!(:user)           { create(:user) }
  let!(:auth_headers)   { auth_user_headers }
  let!(:topic)          { create(:topic) }
  let(:target_params) do
    {
      target: attributes_for(:target,
                             topic_id: topic.id)
    }
  end

  subject do
    post api_v1_targets_path, params: target_params,
                              headers: auth_headers,
                              as: :json
  end

  context 'when valid' do
    it 'gets a successful answer' do
      subject
      expect(response).to be_successful
    end

    it 'creates the target' do
      expect { subject }.to change(Target, :count).by(1)
    end

    it 'belongs to the user' do
      subject
      expect(Target.last.user_id).to eq(user.id)
    end
  end

  context 'when invalid' do
    context 'when not logged in' do
      let!(:auth_headers) { {} }

      it 'gets an unauthorized response' do
        subject
        expect(response).to have_http_status(:unauthorized)
      end

      it 'does not create the target' do
        expect { subject }.not_to change(Target, :count)
      end
    end

    context 'when missing argument' do
      context 'title' do
        before do
          target_params[:target][:title] = nil
        end

        it 'gets a bad request response' do
          subject
          expect(response).to have_http_status(:bad_request)
        end

        it 'returns error message' do
          subject
          expect(parsed_data['error']).to eq(
            "Validation failed: Title can't be blank"
          )
        end
<<<<<<< HEAD

        it 'does not create the target' do
          expect { subject }.not_to change(Target, :count)
        end
      end
    end

    context 'when limit reached' do
      before do
        create_list(:target, 10, user: user, topic: topic)
        subject
      end

      it 'gets a bad_request response' do
        expect(response).to have_http_status(:bad_request)
      end
=======
>>>>>>> 6434290... PR6 fixes

      it 'returns limit error' do
        expect(parsed_data['error'])
          .to eq('Validation failed: Unable to create target, limit reached.')
      end
    end
  end
end
