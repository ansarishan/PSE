class ChangeDecimalScaleForMysqlCompat < ActiveRecord::Migration[6.0]
  def change
    change_column :drug_instruments, :net_revenue_projection, :decimal, precision: 8, scale: 5 
    change_column :drug_periods,     :net_revenue_actual,     :decimal, precision: 8, scale: 5 
    change_column :trades,           :upside_gain,            :decimal, precision: 8, scale: 5 
  end
end
