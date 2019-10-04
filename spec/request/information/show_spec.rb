require 'rails_helper'

describe 'GET #show information', type: :request do
  let!(:information) { create(:information) }

  subject do
    get api_v1_information_path(
      title: information.title
    ), as: :json
  end

  it 'gets a sucessful answer' do
    subject
    expect(response).to be_successful
  end

  it 'returns the proper text' do
    subject
    expect(parsed_data['information']['text']).to eq(information.text)
  end
end
