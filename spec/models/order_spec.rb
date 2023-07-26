require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:di)     { FactoryBot.create(:drug_instrument) }
  let(:org1)   { FactoryBot.create(:organization) }
  let(:org2)   { FactoryBot.create(:organization) }
  let(:order1) { FactoryBot.create(:order) }
  let(:order2) { FactoryBot.create(:order, state: 'accepted', side: 'up',   organization: org1, drug_instrument: di) }
  let(:order3) { FactoryBot.create(:order, state: 'accepted', side: 'down', organization: org2, drug_instrument: di) }
  let(:trade1) { FactoryBot.create(:trade, state: 'unconfirmed', orders: [order2, order3]) }

  context 'simple validations' do
    before(:example) { order1 }

    it { should validate_presence_of(:amount) }
    it { should validate_numericality_of(:amount).is_greater_than(0) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:side) }
    it { should validate_presence_of(:drug_instrument).with_message('must exist') }
    it { should validate_presence_of(:organization).with_message('must exist') }
  end

  context 'custom validations' do
    it '#amount_step_size' do
      order1.amount = 97
      expect(order1.valid?).to eq false
      expect(order1.errors['amount']).to eq ['must be an increment of 50']
    end
  end

  context 'state transitions' do
    before(:example) { trade1 }

    it 'must have State "open" to be canceled by a trader' do
      expect(order1.cancel).to be true
      expect(order2.cancel).to be false
      expect(order3.cancel).to be false
    end

    it 'must have State "accepted" to transition to state "legal_working"' do
      expect { order2.start_contract! }.to_not raise_exception
      reload_all
      expect(trade1.negotiating?).to be true
      expect(order2.legal_working?).to be true

      expect { order3.start_contract! }.to_not raise_exception
      reload_all
      expect(trade1.negotiating?).to be true
      expect(order3.legal_working?).to be true

      expect { order2.start_contract! }.to raise_exception('Cannot Start Contract unless your Order State is Accepted')
      expect { order3.start_contract! }.to raise_exception('Cannot Start Contract unless your Order State is Accepted')

      reload_all
      expect(trade1.negotiating?).to be true
      expect(order2.legal_working?).to be true
      expect(order3.legal_working?).to be true
    end

    it 'must have State "legal_working" to transition to state "legal_approved"' do
      expect { order2.confirm_contract! }.to raise_exception('Cannot Confirm Contract unless your Order State is Legal Working')
      expect { order2.start_contract! }.to_not raise_exception
      expect { order2.confirm_contract! }.to_not raise_exception
      reload_all
      expect(trade1.negotiating?).to be true
      expect(order2.legal_approved?).to be true

      expect { order3.confirm_contract! }.to raise_exception('Cannot Confirm Contract unless your Order State is Legal Working')
      expect { order3.start_contract! }.to_not raise_exception
      expect { order3.confirm_contract! }.to_not raise_exception
      reload_all
      expect(trade1.maturing?).to be true
      expect(order2.legal_approved?).to be true
      expect(order3.legal_approved?).to be true
    end

    it 'can be canceled if the Trade State is "unconfirmed"' do
      expect(trade1.unconfirmed?).to be true
      expect(order2.accepted?).to be true
      expect(order3.accepted?).to be true
      expect { order2.cancel_contract! }.to_not raise_exception
      reload_all
      expect(trade1.canceled?).to be true
      expect(order2.canceled?).to be true
      expect(order3.canceled?).to be true
    end

    it 'can be canceled if the Trade State is "negotiating" and Order State is "legal_working"' do
      expect { order2.start_contract! }.to_not raise_exception
      expect(trade1.negotiating?).to be true
      expect(order2.legal_working?).to be true
      expect(order3.accepted?).to be true
      expect { order2.cancel_contract! }.to_not raise_exception
      reload_all
      expect(trade1.canceled?).to be true
      expect(order2.canceled?).to be true
      expect(order3.canceled?).to be true
    end

    it 'can be canceled if the Trade State is "negotiating" and Order State is "legal_approved"' do
      expect { order2.start_contract! }.to_not raise_exception
      expect { order2.confirm_contract! }.to_not raise_exception
      expect(trade1.negotiating?).to be true
      expect(order2.legal_approved?).to be true
      expect(order3.accepted?).to be true
      expect { order2.cancel_contract! }.to_not raise_exception
      reload_all
      expect(trade1.canceled?).to be true
      expect(order2.canceled?).to be true
      expect(order3.canceled?).to be true
    end

    it 'cannot be canceled if unless Trade State is "unconfirmed" or "negotiating"' do
      expect { order2.start_contract! }.to_not raise_exception
      expect { order2.confirm_contract! }.to_not raise_exception
      expect { order3.start_contract! }.to_not raise_exception
      expect { order3.confirm_contract! }.to_not raise_exception
      reload_all
      expect(trade1.maturing?).to be true
      expect(order2.legal_approved?).to be true
      expect(order3.legal_approved?).to be true
      expect { order2.cancel_contract! }.to raise_exception('Cannot Cancel Contract unless Trade State is Unconfirmed or Negotiating')
    end
  end

  def reload_all
    trade1.reload
    order1.reload
    order2.reload
    order3.reload
  end
end
