FactoryBot.define do
  factory :drug_period do
    drug
    sequence(:label) {|n| "dp-#{n}" }
    period_type { 'Quarterly' }
    status { 'closed' }
    region { Region.first || FactoryBot.create(:usa_region) }

    factory :open_drug_period do
      status { 'open' }
    end
  end
end
