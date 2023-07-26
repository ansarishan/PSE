require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user1) { FactoryBot.create(:user) }

  context 'simple validations' do
    before(:example) { user1 }

    it { should validate_uniqueness_of(:username) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:role) }
    it { should validate_presence_of(:organization) }

    it { should allow_value(true).for(:has_signed_eula) }
    it { should allow_value(false).for(:has_signed_eula) }
    it { should_not allow_value(nil).for(:has_signed_eula) }

    it { should allow_value(true).for(:onboarded) }
    it { should allow_value(false).for(:onboarded) }
    it { should_not allow_value(nil).for(:onboarded) }

    it { should allow_value(true).for(:legal_is_separate) }
    it { should allow_value(false).for(:legal_is_separate) }
    it { should_not allow_value(nil).for(:legal_is_separate) }
  end

  context 'password' do
    it 'can be blank' do
      user1.password = ' '
      expect(user1.valid?).to eq true
    end

    it 'is valid if it matches confirmation' do
      user1.password = user1.password_confirmation = 'Password123!'
      expect(user1.valid?).to eq true
    end

    it 'is invalid if it does not match confirmation' do
      user1.password = 'Password123!'
      user1.password_confirmation = 'TotallyDifferent'
      expect(user1.valid?).to eq false
      expect(user1.errors.messages[:password_confirmation].first).to eq "doesn't match Password"
    end

    it 'must be >6 characters' do
      user1.password = user1.password_confirmation = 'short'
      expect(user1.valid?).to eq false
      expect(user1.errors.messages[:password].first).to eq "is too short (minimum is 6 characters)"
    end
  end

  it 'does not validate uniqueness of blank usernames' do
    u1 = FactoryBot.create(:user, username: nil)
    u2 = FactoryBot.build(:user, username: nil)
    expect(u2.valid?).to eq true
  end

  it 'admin can be org-less' do
    admin = FactoryBot.build(:admin)
    expect(admin.organization).to eq nil
    expect(admin.valid?).to eq true
  end

  context 'validate org does not have this role already' do
    let(:xorg) { FactoryBot.create(:organization) }

    it '(vs db user)' do
      FactoryBot.create(:user, organization: xorg, role: 'trader')
      xorg.reload
      u2 = FactoryBot.build(:user, organization: xorg, role: 'trader')
      expect(u2.valid?).to eq false
      expect(u2.errors.messages[:organization].first).to eq 'already has a user of this type'
    end

    it '(vs in-memory org user)' do
      xorg.users << FactoryBot.build(:user, organization: xorg, role: 'trader')
      u2 = FactoryBot.build(:user, organization: xorg, role: 'trader')
      expect(u2.valid?).to eq false
      expect(u2.errors.messages[:organization].first).to eq 'already has a user of this type'
    end
  end

  context 'email' do
    it 'valid' do
      user1.email = 'foo@foo.com'
      expect(user1.valid?).to eq true
    end

    it 'invalid' do
      user1.email = 'foo.com'
      expect(user1.valid?).to eq false
    end
  end
end
