FactoryBot.define do
  factory :drug do
    sequence(:brand_name) {|n| "DrugX-#{n}" }
    drug_company { DrugCompany.first || FactoryBot.create(:drug_company) }
  end
end
