class CreateDrugInstruments < ActiveRecord::Migration[6.0]
  def change
    create_table :drug_instruments do |t|
      t.references :drug_period, null: false, foreign_key: true
      t.integer :up_leverage_factor, null: false
      t.integer :down_leverage_factor, null: false
      t.integer :up_return_cap, null: false
      t.integer :down_return_cap, null: false
      t.decimal :net_revenue_projection, null: false

      t.timestamps
    end
  end
end
