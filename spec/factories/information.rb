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

FactoryBot.define do
  factory :information do
    title          { 0 }
    text           { Faker::Lorem.sentence(word_count: 20) }
  end
end
