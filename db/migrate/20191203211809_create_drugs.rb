class CreateDrugs < ActiveRecord::Migration[6.0]
  def change
    create_table :drugs do |t|
      t.string :name, null: false
      t.references :drug_company, null: false

      t.timestamps
    end
  end
end
