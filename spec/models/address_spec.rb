require 'rails_helper'

RSpec.describe Address, type: :model do
  let(:address1) { FactoryBot.create(:user) }

  context 'simple validations' do
    before(:example) { address1 }

    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:country) }
  end
end
