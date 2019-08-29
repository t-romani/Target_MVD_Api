class CreateTopics < ActiveRecord::Migration[5.2]
  def change
    create_table :topics do |t|
      t.text :title, null: false

      t.timestamps
    end

    add_index :topics, :title, unique: true
  end
end
