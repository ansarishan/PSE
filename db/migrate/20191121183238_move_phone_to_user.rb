class MovePhoneToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :phone, :string
    remove_column :addresses, :phone, :string
  end
end
