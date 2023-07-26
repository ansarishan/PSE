class AddUsernameToUsers < ActiveRecord::Migration[6.0]

  class User < ActiveRecord::Base
  end

  def up
    add_column :users, :username, :string
    User.all.each do |u|
      u.username = Mail::Address.new(u.email).local
      u.save!
    end

    change_column :users, :username, :string, null: false
    add_index :users, :username, unique: true
  end

  def down
    remove_column :users, :username
  end
end
