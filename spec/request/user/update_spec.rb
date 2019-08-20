require 'rails_helper'

describe 'PATCH #update user params', type: :request do
  let!(:user) { create(:user, :confirmed, gender: 'male') }
  let!(:name) { Faker::Name.name_with_middle }
  let!(:last_user) { User.last }
  subject do
    patch api_v1_user_path(id: user.id), params: user_params,
                                         headers: auth_headers,
                                         as: :json
  end

  context 'when valid' do
    let!(:auth_headers) { auth_user_headers }
    context 'when changing name' do
      let(:user_params) { { user: { full_name: name } } }

      it 'does get a successful answer' do
        subject
        expect(response).to be_successful
      end

      it 'does change the name' do
        expect { subject }.to(change { User.last.full_name })
      end
    end
    context 'when changing gender' do
      let(:user_params) { { user: { gender: 'female' } } }
      it 'does get a successful answer' do
        subject
        expect(response).to be_successful
      end

      it 'does change the gender' do
        expect { subject }.to(change { User.last.gender })
      end
    end
  end

  context 'when invalid' do
    let(:user_params) { { user: { full_name: name, gender: 'female' } } }
    context 'when signed out' do
      let!(:auth_headers) { {} }
      it 'does get a unauthorized answer' do
        subject
        expect(response).to have_http_status(:unauthorized)
      end

      it 'does not change the name/gender' do
        expect { subject }.not_to(change { User.last.attributes})
      end
    end

    context 'when signed in' do
      let!(:auth_headers) { auth_user_headers }
      context 'when gender invalid' do
        let(:user_params) { { user: { gender: 'invalid' } } }
        it 'does get a bad request answer' do
          subject
          expect(response).to have_http_status(:bad_request)
        end

        it 'does not change the name/gender' do
          expect { subject }.not_to(change { User.last.attributes })
        end
      end
    end
  end
end
