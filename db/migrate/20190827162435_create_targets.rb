class CreateTargets < ActiveRecord::Migration[5.2]
  def change
    create_table :targets do |t|
      t.references  :topic, null: false
      t.references  :user, null: false
      t.string      :title, null: false
      t.float       :radius, null: false
      t.float       :latitude, null: false
      t.float       :longitude, null: false

      t.timestamps
    end

    add_index(:targets, %i[topic_id title user_id], unique: true)
  end
end
