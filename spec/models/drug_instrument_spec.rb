require 'rails_helper'

RSpec.describe DrugInstrument, type: :model do
  let(:di1) { FactoryBot.create(:drug_instrument) }

  context 'simple validations' do
    before(:example) { di1 }
    it { should validate_presence_of(:drug_period).with_message('must exist') }
    it { should validate_presence_of(:up_leverage_factor) }
    it { should validate_presence_of(:down_leverage_factor) }
    it { should validate_presence_of(:up_return_cap) }
    it { should validate_presence_of(:down_return_cap) }
    it { should validate_presence_of(:net_revenue_projection) }
  
    it { should validate_numericality_of(:up_leverage_factor).is_greater_than(0) }
    it { should validate_numericality_of(:down_leverage_factor).is_greater_than(0) }
    it { should validate_numericality_of(:up_return_cap).is_greater_than(0) }
    it { should validate_numericality_of(:down_return_cap).is_greater_than(0) }
    it { should validate_numericality_of(:net_revenue_projection).is_greater_than(0) }
  end

  it 'delegates Status and NetRevenue Actual to its DrugPeriod' do
    expect(di1.drug_period.status).to eq 'closed'
    expect(di1.status).to eq di1.drug_period.status
    expect(di1.net_revenue_actual).to be_nil

    di1.drug_period.net_revenue_actual = 867.5309
    di1.drug_period.status = 'expired'
    di1.drug_period.save!
    di1.reload

    expect(di1.status).to eq 'expired'
    expect(di1.net_revenue_actual).to eq 867.5309
  end

  context 'open vol functions' do
    before(:example) do
      FactoryBot.create(:order, drug_instrument: di1, side: 'up', amount: 1000, state: 'open')
      FactoryBot.create(:order, drug_instrument: di1, side: 'up', amount:  500, state: 'open')
      FactoryBot.create(:order, drug_instrument: di1, side: 'up', amount:   50, state: 'accepted')
      FactoryBot.create(:order, drug_instrument: di1, side: 'down', amount:   50, state: 'accepted')
      FactoryBot.create(:order, drug_instrument: di1, side: 'down', amount:  200, state: 'open')
      FactoryBot.create(:order, drug_instrument: di1, side: 'down', amount: 2000, state: 'open')
    end

    it '#up_open_vol' do
      expect(di1.up_open_vol).to eq 1500
    end

    it '#down_open_vol' do
      expect(di1.down_open_vol).to eq 2200
    end
  end

  def create_trade(di, amount, state)
    o1 = FactoryBot.create(:order, drug_instrument: di, side: 'up', amount: amount, state: 'legal_approved')
    o2 = FactoryBot.create(:order, drug_instrument: di, side: 'down', amount: amount, state: 'legal_approved')
    FactoryBot.create(:trade, state: state, orders: [o1, o2])
  end

  it '#closed_vol' do
    create_trade(di1, 10000, 'maturing')
    create_trade(di1,  1100, 'maturing')
    create_trade(di1,   300, 'settled')
    expect(di1.closed_vol).to eq 11100
  end
end
