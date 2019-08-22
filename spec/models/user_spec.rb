require 'rails_helper'
RSpec.describe User, :type => :model do
  subject do
    @user1 = FactoryBot.create(:user)
  end

  describe '#valid attributes' do
    it 'is valid with valid attributes' do
      subject
      expect(@user1).to be_valid
    end
  end

  describe '#unique mail, (uid,provider)' do
    it 'has a unique email' do
      subject
      user2 = build(:user)
      expect(user2).to_not be_valid
    end

    it 'has a unique (uid,provider)' do
      subject
      user2 = build(:user, email: 'test_user1@example.com')
      expect([@user1.uid, @user1.provider]).to_not eq [
        user2.uid, user2.provider
      ]
    end
  end

  describe '#valid presence of password, email, gender' do
    it 'is not valid without a password' do
      subject
      user2 = build(:user, password: nil)
      expect(user2).to_not be_valid
    end

    it 'is not valid without an email' do
      subject
      user2 = build(:user, email: nil)
      expect(user2).to_not be_valid
    end

    it 'is not valid without an gender' do
      subject
      user2 = build(:user, gender: nil)
      expect(user2).to_not be_valid
    end
  end
end
