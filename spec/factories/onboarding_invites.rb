FactoryBot.define do
  factory :onboarding_invite do
    sequence(:url_code) {|n| "abacadaba-#{n}" }
    sequence(:email) {|n| "onboard-#{n}@example.com"}
  end
end
