require 'rails_helper'

describe 'PATCH #update user params', type: :request do
  let!(:user)         { create(:user, gender: 'male') }
  let!(:name)         { Faker::Name.name_with_middle }
  let!(:auth_headers) { auth_user_headers }

  subject do
    patch api_v1_user_path(id: user.id), params: user_params,
                                         headers: auth_headers,
                                         as: :json
  end

  context 'when valid' do
    context 'when changing name' do
      let(:user_params) { { user: { full_name: name } } }

      it 'does get a successful answer' do
        subject
        expect(response).to be_successful
      end

      it 'does change the name' do
        expect { subject }.to change {
          user.reload.full_name
        }.from(user.full_name).to(name)
      end
    end

    context 'when changing gender' do
      let(:user_params) { { user: { gender: 'female' } } }

      it 'does get a successful answer' do
        subject
        expect(response).to be_successful
      end

      it 'does change the gender' do
        expect { subject }.to change {
          user.reload.gender
        }.from('male').to('female')
      end
    end
  end

  context 'when invalid' do
    let(:user_params) { { user: { full_name: name, gender: 'female' } } }

    context 'when signed out' do
      let!(:auth_headers) { {} }

      it 'does get an unauthorized answer' do
        subject
        expect(response).to have_http_status(:unauthorized)
      end

      it 'does not change the name/gender' do
        expect { subject }.not_to(change { user.reload.full_name })
      end
    end

    context 'when signed in' do
      context 'when gender invalid' do
        let(:user_params) { { user: { gender: 'invalid' } } }

        it 'does get a bad request answer' do
          subject
          expect(response).to have_http_status(:bad_request)
        end

        it 'does not change the name/gender' do
          expect { subject }.not_to(change do
            [user.reload.full_name, user.reload.gender]
          end)
        end
      end
    end
  end
end
