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

class Contact < ApplicationRecord
  belongs_to :user

  validates :text, presence: true
end
