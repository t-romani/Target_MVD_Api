class AddAllowPasswordChangeToUsers < ActiveRecord::Migration[5.2]
  def change
    change_table :users do |t|
      t.boolean  :allow_password_change, default: false, null: false
    end
  end
end
