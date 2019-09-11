require 'rails_helper'

describe 'POST #delete target', type: :request do
  let!(:user)           { create(:user) }
  let!(:target)         { create(:target, user: user) }
  let(:data)            { parsed_data }
  let(:target_id)       { target.id }

  subject do
    delete api_v1_target_path(id: target_id), headers: auth_headers, as: :json
  end

  context 'when valid' do
    context 'when signed in' do
      let!(:auth_headers) { auth_user_headers }

      it 'gets a sucessful answer' do
        subject
        expect(response).to be_successful
      end

      it 'does delete the target' do
        expect { subject }.to change(user.targets.reload, :count).by(-1)
      end
    end
  end

  context 'when invalid' do
    let!(:auth_headers) { {} }
    it 'gets a unauthorized error' do
      subject
      expect(response).to have_http_status(:unauthorized)
    end

    it 'does not modify targets' do
      expect { subject }.not_to change(user.targets.reload, :count)
    end
  end

  context 'when invalid target id' do
    let!(:auth_headers)    { auth_user_headers }
    let!(:another_target)  { create(:target) }
    let!(:target_id)       { { id: another_target.id } }

    it 'gets not_found status' do
      subject
      expect(response).to have_http_status(:not_found)
    end

    it 'gets not_found error' do
      subject
      expect(data['error'])
        .to eq(I18n.t('api.error.invalid_request.content_not_found'))
    end
  end
end
