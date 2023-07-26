require 'rails_helper'

RSpec.describe Drug, type: :model do
  let(:drug1) { FactoryBot.create(:drug) }

  context 'simple validations' do
    before(:example) { drug1 }

    it { should validate_presence_of(:drug_company) }
    it { should validate_presence_of(:brand_name) }
    it { should validate_uniqueness_of(:brand_name).scoped_to(:drug_company_id).
                  with_message('has already been taken for this company') }
  end
end
