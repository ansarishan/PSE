FactoryBot.define do
  factory :order do
    amount { 1000 }
    state { 'open' }
    side { 'up' }
    drug_instrument { FactoryBot.create(:open_drug_instrument) }
    organization { FactoryBot.create(:organization) }
    trade { nil }
  end
end
