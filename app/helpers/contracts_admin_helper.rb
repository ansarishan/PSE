module ContractsAdminHelper
  def periods_tree(drug)
    rv = {}
    drug.drug_periods.order(:label).each do |dp|
      if dp.drug_instruments.count > 0
        (rv[dp.period_type] ||= []) << dp
      end
    end
    rv
  end
end
