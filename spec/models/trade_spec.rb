require 'rails_helper'

RSpec.describe Trade, type: :model do
  let(:trade1) { FactoryBot.create(:trade) }

  context 'simple validations' do
    before(:example) { trade1 }

    it { should validate_presence_of(:state) }
  end

  context 'custom validations' do
    it '#exactly_2_orders' do
      tradeX = FactoryBot.build(:trade, orders: [])
      tradeX.orders << FactoryBot.create(:order)
      expect(tradeX.valid?).to eq false
      expect(tradeX.errors['orders']).to eq ['must have exactly 2 Orders']
    end

    it '#above_and_below' do
      trade1.orders[0].update(side: 'up')
      trade1.orders[1].update(side: 'up')
      expect(trade1.valid?).to eq false
      expect(trade1.errors['orders']).to eq ['must have 1 Above order and 1 Below order']
    end

    it '#settled_with_upside_gain' do
      trade1.state = 'settled'
      expect(trade1.valid?).to eq false
      expect(trade1.errors['upside_gain']).to eq ['must be set if state=settled']
    end

    it '#equal_amounts' do
      trade1.orders[0].amount = 55
      trade1.orders[1].amount = 66
      expect(trade1.valid?).to eq false
      expect(trade1.errors['orders']).to eq ['must have equal amounts']
    end

    it '#same_instrument' do
      trade1.orders[0].drug_instrument = FactoryBot.create(:drug_instrument)
      expect(trade1.valid?).to eq false
      expect(trade1.errors['orders']).to eq ['must have the same drug_instrument']
    end
  end

  it '.for_drug_period' do
    di = FactoryBot.create(:drug_instrument)
    dp = di.drug_period
    FactoryBot.create(:trade, state: 'maturing', orders: [
      FactoryBot.create(:order, side: 'up', state: 'legal_approved', drug_instrument: di),
      FactoryBot.create(:order, side: 'down', state: 'legal_approved', drug_instrument: di)] )
    FactoryBot.create(:trade, state: 'negotiating', orders: [
      FactoryBot.create(:order, side: 'up', state: 'legal_approved', drug_instrument: di),
      FactoryBot.create(:order, side: 'down', state: 'legal_approved', drug_instrument: di)] )
    FactoryBot.create(:trade) #garbage

    expect(Trade.for_drug_period(dp).count).to eq 2
    expect(Trade.for_drug_period(dp, {state: 'maturing'}).count).to eq 1
    expect(Trade.for_drug_period(dp, {state: 'negotiating'}).count).to eq 1
    expect(Trade.for_drug_period(dp, {state: 'unconfirmed'}).count).to eq 0
  end

  context '#calculate_upside_gain' do
    # The function takes parameters in the scale/types that the UI accepts them:
    # actual (B), projection (B), amount (k), up_lev (int), up_cap (int%), down_lev (int), down_cap (int%)

    # returns whole dollar value (not in millions or whatever)

    it 'above projection, under cap' do
      expect(Trade.calculate_upside_gain(11, 10, 1000, 2, 40, 2, 40)).to eq 200000
    end

    it 'above projection, over cap' do
      expect(Trade.calculate_upside_gain(13, 10, 1000, 2, 40, 2, 40)).to eq 400000
    end

    it 'under projection, under cap' do
      expect(Trade.calculate_upside_gain( 9, 10, 1000, 2, 40, 2, 40)).to eq -200000
    end

    it 'under projection, over cap' do
      expect(Trade.calculate_upside_gain( 7, 10, 1000, 2, 40, 2, 40)).to eq -400000
    end
  end
end
