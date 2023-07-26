class RemoveRegionFromDrugCompanies < ActiveRecord::Migration[6.0]
  def change
    remove_column :drug_companies, :region_id
  end
end
