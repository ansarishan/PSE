FactoryBot.define do
  factory :address do
    association :user
    line1 { '123 Main St.' }
    line2 { 'Suite 999' }
    city { 'Young America' }
    state { 'MN' }
    postcode { '55555' }
    country { 'USA' }
  end
end
