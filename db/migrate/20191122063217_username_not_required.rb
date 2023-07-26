class UsernameNotRequired < ActiveRecord::Migration[6.0]
  def up
    change_column :users, :username, :string, null: true
  end

  def down
    change_column :users, :username, :string, null: false
  end
end
