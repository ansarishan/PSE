FactoryBot.define do
  factory :organization do
    sequence(:name) {|n| "Acme-#{n}"}
  end
end
