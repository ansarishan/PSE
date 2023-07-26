class RenameDrugNameToDrugBrandName < ActiveRecord::Migration[6.0]
  def change
    rename_column :drugs, :name, :brand_name
  end
end
