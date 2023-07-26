require 'rails_helper'

RSpec.describe DrugCompany, type: :model do
  let(:drugco1) { FactoryBot.create(:drug_company) }

  context 'simple validations' do
    before(:example) { drugco1 }

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end
end
