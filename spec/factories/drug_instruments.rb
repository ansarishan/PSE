FactoryBot.define do
  factory :drug_instrument do
    drug_period

    up_leverage_factor { 2 }
    down_leverage_factor { 2 }
    up_return_cap { 30 }
    down_return_cap { 40 }
    net_revenue_projection { 5.5 }

    factory :open_drug_instrument do
      drug_period { FactoryBot.create(:open_drug_period) }
    end
  end
end
