require 'rails_helper'

RSpec.describe OnboardingInvite, type: :model do
  let(:invite) { FactoryBot.create(:onboarding_invite) }

  context 'simple validations' do
    it { should validate_presence_of(:url_code) }
    it { should validate_presence_of(:email) }
  end
end
