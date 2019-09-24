class AddUnreadMessagesToConversationUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :conversation_users, :unread_messages,
               :integer, default: 0, null: false
  end
end
