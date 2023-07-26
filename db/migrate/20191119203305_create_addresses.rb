class CreateAddresses < ActiveRecord::Migration[6.0]
  def change
    create_table :addresses do |t|
      t.references :user, null: false, foreign_key: true
      t.string :phone
      t.string :line1
      t.string :line2
      t.string :city, null: false
      t.string :state
      t.string :postcode
      t.string :country, null: false

      t.timestamps
    end
  end
end
