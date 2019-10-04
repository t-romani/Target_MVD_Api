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

class Information < ApplicationRecord
  enum title: { about: 0 }

  validates :title, presence: true, uniqueness: true
  validates :text, presence: true

  def to_param
    title
  end
end
