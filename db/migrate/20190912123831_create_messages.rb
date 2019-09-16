class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.references  :user
      t.references  :conversation, null: false, index: true
      t.text        :text, null: false

      t.timestamps
    end
  end
end
