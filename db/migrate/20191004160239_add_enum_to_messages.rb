class AddEnumToMessages < ActiveRecord::Migration[5.2]
  def change
    add_column :messages, :message_type,
               :integer, null: false, default: 0
  end
end
