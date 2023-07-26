class AddRegionToDrugPeriods < ActiveRecord::Migration[6.0]
  def change
    add_reference :drug_periods, :region, null: true, foreign_key: true
    DrugPeriod.find_each do |dp|
      dp.update!(region_id: dp.drug.drug_company.region_id)
    end
    change_column_null :drug_periods, :region_id, false
  end
end
