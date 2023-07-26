FactoryBot.define do
  factory :drug_company do
    sequence(:name) {|n| "Pharm#{n} Corp" }
  end
end
