require 'rails_helper'

describe 'POST #create contact', type: :request do
  let!(:user)            { create(:user) }
  let!(:auth_headers)    { auth_user_headers }
  let!(:contact_params)  { attributes_for(:contact, user: user) }

  subject do
    post api_v1_contacts_path, params: contact_params,
                               headers: auth_headers,
                               as: :json
  end

  describe 'when valid' do
    it 'gets a successful answer' do
      subject
      expect(response).to be_successful
    end

    it 'creates the contact instance' do
      expect { subject }.to change(Contact, :count).by(1)
    end

    it 'belongs to the user' do
      subject
      expect(Contact.last.user_id).to eq(user.id)
    end

    it 'sends the email' do
      expect { subject }.to have_enqueued_job.on_queue('mailers')
    end
  end

  describe 'when invalid' do
    context 'when not logged in' do
      let!(:auth_headers) { {} }

      it 'gets an unauthorized response' do
        subject
        expect(response).to have_http_status(:unauthorized)
      end

      it 'does not create the contact instance' do
        expect { subject }.not_to change(Contact, :count)
      end
    end

    context 'when empty text' do
      let!(:contact_params) { { text: '', user_id: user.id } }

      it 'gets an bad_request response' do
        subject
        expect(response).to have_http_status(:bad_request)
      end

      it 'does not create the contact instance' do
        expect { subject }.not_to change(Contact, :count)
      end
    end
  end
end
