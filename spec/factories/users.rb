FactoryBot.define do
  factory :user do
    association :organization
    sequence(:username) {|n| "user#{n}" }
    sequence(:email) {|n| "#{username||"nil-#{n}"}@example.com"}
    has_signed_eula { false }
    onboarded { false }
    role { 'org_admin' }
    legal_is_separate { false }
    password { 'Password123!' }
    password_confirmation { 'Password123!' }

    factory :trader, class: User do
      role { 'trader' }
      has_signed_eula { true }
      onboarded { true }
    end
    factory :analyst, class: User do
      role { 'analyst' }
      has_signed_eula { true }
      onboarded { true }
    end
    factory :lawyer, class: User do
      role { 'legal' }
      has_signed_eula { true }
      onboarded { true }
    end
  end
end

FactoryBot.define do
  factory :admin, class: User do
    organization { nil }
    sequence (:username) {|n| "admin#{n}" }
    sequence(:email) {|n| "#{username||"niladmin-#{n}"}@example.com"}
    role { 'admin' }
    password { 'Password123!' }
    password_confirmation { 'Password123!' }
  end
end

