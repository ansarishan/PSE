class AddOnboardingFieldsToUsers < ActiveRecord::Migration[6.0]
  def up
    add_column :users, :has_signed_eula, :boolean, null: false, default: false
    add_column :users, :onboarded, :boolean, null: false, default: false

    add_column :users, :role, :integer
    User.all.each do |u|
      u.role = 0
      u.save!
    end
    change_column :users, :role, :integer, null: false
  end

  def down
    remove_column :users, :has_signed_username
    remove_column :users, :onboarded
    remove_column :users, :role
  end
end
