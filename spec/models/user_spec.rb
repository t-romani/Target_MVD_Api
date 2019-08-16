require 'rails_helper'
describe User, :type => :model do
  subject { build(:user) }

  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:gender) }
    it { should validate_presence_of(:full_name) }
  end

  describe 'email uniqueness' do
    it 'should not be valid' do
      user1 = create(:user)
      expect(subject).to_not be_valid
    end
  end
end
