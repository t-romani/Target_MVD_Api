class CreateTargets < ActiveRecord::Migration[5.2]
  def change
    create_table :targets do |t|
      t.belongs_to  :topic, null: false
      t.belongs_to  :user, null: false
      t.string      :title, null: false
      t.float       :radius, :latitude, :longitude, null: false

      t.timestamps
    end

    add_foreign_key(:targets, :topics)
    add_foreign_key(:targets, :users)
    add_index(:targets, %i[topic_id title user_id], unique: true)
  end
end
