class AddInformation < ActiveRecord::Migration[5.2]
  def change
    create_table :information do |t|
      t.integer  :title, null: false
      t.text     :text
    end

    add_index(:information, :title , unique: true)
  end
end
