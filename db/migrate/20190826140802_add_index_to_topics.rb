class AddIndexToTopics < ActiveRecord::Migration[5.2]
  def change
    add_index :topics, %i[title], unique: true
  end
end
