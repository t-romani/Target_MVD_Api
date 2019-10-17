# == Schema Information
#
# Table name: information
#
#  id    :bigint           not null, primary key
#  text  :text
#  title :integer          not null
#
# Indexes
#
#  index_information_on_title  (title) UNIQUE
#

require 'rails_helper'

describe Information, type: :model do
  subject { build(:information) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:text) }
  end
end
