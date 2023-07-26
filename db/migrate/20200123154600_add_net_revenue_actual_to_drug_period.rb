class AddNetRevenueActualToDrugPeriod < ActiveRecord::Migration[6.0]
  def change
    add_column :drug_periods, :net_revenue_actual, :decimal
    add_column :drug_periods, :status, :integer, null: false, default: 0
  end
end
