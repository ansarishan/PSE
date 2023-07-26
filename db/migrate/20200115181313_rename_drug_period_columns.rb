class RenameDrugPeriodColumns < ActiveRecord::Migration[6.0]
  def change
    rename_column :drug_periods, :length_category, :period_type
    rename_column :drug_periods, :name, :label
  end
end
