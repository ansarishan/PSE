class AddRangesToDrugPeriod < ActiveRecord::Migration[6.0]
  def change
    add_column :drug_periods, :trailing_period_date_range, :string
    add_column :drug_periods, :prediction_period_date_range, :string
  end
end
