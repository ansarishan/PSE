require 'rails_helper'

RSpec.describe Organization, type: :model do
  let(:org1) { FactoryBot.create(:organization) }

  #context 'simple validations' do
  #  before(:example) { org1 }
  #  it { should validate_presence_of(:some_var) }
  #end

  context 'validation one_of_each_user_type' do
    before(:each) do
      FactoryBot.create(:user, organization: org1, role: 'org_admin')
      FactoryBot.create(:user, organization: org1, role: 'legal')
      org1.reload
    end
    it 'flags >1 org admin user' do
      org1.users[0].role = org1.users[1].role = 'org_admin'
      expect(org1.valid?).to eq false
      expect(org1.errors.messages[:users].first).to eq 'can not have more than 1 Organizational Admin user'
    end
    it 'flags >1 legal' do
      org1.users[0].role = org1.users[1].role = 'legal'
      expect(org1.valid?).to eq false
      expect(org1.errors.messages[:users].first).to eq 'can not have more than 1 Legal user'
    end
    it 'flags >1 trader' do
      org1.users[0].role = org1.users[1].role = 'trader'
      expect(org1.valid?).to eq false
      expect(org1.errors.messages[:users].first).to eq 'can not have more than 1 Trader user'
    end
    it 'flags >1 analyst' do
      org1.users[0].role = org1.users[1].role = 'analyst'
      expect(org1.valid?).to eq false
      expect(org1.errors.messages[:users].first).to eq 'can not have more than 1 Analyst user'
    end
  end
end
