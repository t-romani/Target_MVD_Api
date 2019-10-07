class CreateConversations < ActiveRecord::Migration[5.2]
  def change
    create_table(:conversations, &:timestamps)

    create_table :conversation_users, bulk: true do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :conversation, null: false, foreign_key: true
    end

    add_index(:conversation_users, %i[user_id conversation_id], unique: true)
  end
end
