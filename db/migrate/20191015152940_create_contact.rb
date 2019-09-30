class CreateContact < ActiveRecord::Migration[5.2]
  def change
    create_table :contacts do |t|
      t.references :user, null: false
      t.text       :text, null: false
    end
  end
end
