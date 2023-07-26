class IncreaseDecimalPrecision < ActiveRecord::Migration[6.0]
  def change
    change_column :drug_instruments, :net_revenue_projection, :decimal, precision: 12 + 5, scale: 5 
    change_column :drug_periods,     :net_revenue_actual,     :decimal, precision: 12 + 5, scale: 5 
    change_column :trades,           :upside_gain,            :decimal, precision: 12 + 5, scale: 5 
  end
end
