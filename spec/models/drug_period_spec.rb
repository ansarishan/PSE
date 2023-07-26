require 'rails_helper'

RSpec.describe DrugPeriod, type: :model do
  let(:dp1) { FactoryBot.create(:drug_period) }

  context 'simple validations' do
    before(:example) { dp1 }

    it { should validate_presence_of(:label) }
    it { should validate_uniqueness_of(:label).scoped_to(:drug_id).
         with_message('has already been taken for this drug') }
    it { should validate_presence_of(:drug) }
    it { should validate_presence_of(:period_type) }
    it { should_not allow_value('Voldemort').for(:period_type) }
  end

  it 'must have Status "expired" if Net Revenue Actual is not nil' do
    drug_period = FactoryBot.create(:drug_period, status: 'closed')
    expect(drug_period.valid?).to eq true
    drug_period.status = 'expired'
    expect(drug_period.valid?).to eq false
    expect(drug_period.errors[:drug_period].first).to eq 'Net Revenue Actual cannot be blank when Status is expired'
  end

  it 'must not have Status "expired" if Net Revenue Actual is nil' do
    (DrugPeriod.statuses.keys - ['expired']).each do |status|
      drug_period = FactoryBot.create(:drug_period, status: status)
      expect(drug_period.valid?).to eq true
      drug_period.net_revenue_actual = 1234.56789
      expect(drug_period.valid?).to eq false
      expect(drug_period.errors[:drug_period].first).to eq 'Status must be expired when Net Revenue Actual is not blank'
    end
  end
end
