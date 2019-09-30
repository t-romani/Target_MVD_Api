class AddPlayerIdToAdmin < ActiveRecord::Migration[5.2]
  def change
    add_column :admin_users, :player_id, :string
  end
end
