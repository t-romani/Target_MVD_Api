require 'rails_helper'
describe User, :type => :model do
  subject { build(:user) }

  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:gender) }
    it { should validate_presence_of(:full_name) }
    it { should validate_uniqueness_of(:email).scoped_to(:provider).ignoring_case_sensitivity}
  end
end
