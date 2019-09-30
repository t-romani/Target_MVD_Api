# == Schema Information
#
# Table name: contacts
#
#  id      :bigint           not null, primary key
#  text    :text             not null
#  user_id :bigint           not null
#
# Indexes
#
#  index_contacts_on_user_id  (user_id)
#

require 'rails_helper'

describe Contact, type: :model do
  subject { build(:contact) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:text) }
    it { is_expected.to belong_to(:user) }
  end
end
