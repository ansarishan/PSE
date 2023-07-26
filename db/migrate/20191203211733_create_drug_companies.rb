class CreateDrugCompanies < ActiveRecord::Migration[6.0]
  def change
    create_table :drug_companies do |t|
      t.string :name, null: false
      t.references :region

      t.timestamps
    end
  end
end
