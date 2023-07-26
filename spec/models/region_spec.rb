require 'rails_helper'

RSpec.describe Region, type: :model do
  let(:usa_region) { FactoryBot.create(:usa_region) }

  context 'simple validations' do
    before(:example) { usa_region }

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should_not allow_value('Mordor').for(:name) }
  end
end
