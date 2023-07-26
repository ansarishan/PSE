class CreateDrugPeriods < ActiveRecord::Migration[6.0]
  def change
    create_table :drug_periods do |t|
      t.references :drug, null: false, foreign_key: true
      t.string :name, null: false
      t.string :length_category, null: false

      t.timestamps
    end
  end
end
