class CreateOrganizations < ActiveRecord::Migration[6.0]
  def change
    create_table :organizations do |t|
      t.string :name

      t.timestamps
    end

    add_reference :users, :organization
  end
end
