require 'rails_helper'

describe 'POST #update password', type: :request do
  let!(:user) { create(:user) }

  subject do
    post user_password_path, params: {
      email: user[:email]
    }, as: :json
  end

  it 'returns ok status' do
    subject
    expect(response).to be_successful
  end

  it 'returns success message' do
    subject
    expect(parsed_data['success']).to eq(true)
  end

  it 'creates reset_password_token' do
    expect { subject }.to(change { User.last.reset_password_token })
  end

  it 'sends an email' do
    expect(ActionMailer::Base.deliveries.count(1))
  end
end
