require 'rails_helper'

RSpec.describe OrdersController, type: :controller do

  context 'trader user' do
    let(:user)  { FactoryBot.create(:trader) }

    before(:each) do
      login(user)
    end

    it 'can submit an order' do
      order = FactoryBot.build(:order)
      post :create, params: { order: order.as_json }
      expect(response.status).to eq(302)
      expect(flash[:notice]).to eq 'Order created.'
      expect(flash[:alert]).to be_nil

      expect(Order.count).to eq 1
    end

    it 'cannot submit an order for a not-open DrugPeriod' do
      di = FactoryBot.create(:drug_instrument)
      expect(di.drug_period.status).to eq 'closed'

      order = FactoryBot.build(:order, drug_instrument: di)
      post :create, params: { order: order.as_json }
      expect(response.status).to eq(302)
      expect(flash[:notice]).to be_nil
      expect(flash[:alert]).to include 'period is not open'

      expect(Order.count).to eq 0
    end

    it 'can cancel an order' do
      order = FactoryBot.create(:order, organization_id: user.organization_id)
      expect {
        delete :destroy, params: { id: order.id }
      }.to change(Order.where(state: 'canceled'), :count).by(1)
      expect(flash[:notice]).to eq 'Order canceled.'
      expect(flash[:alert]).to be_nil
    end

    it 'cannot cancel orders that belong to other organizations' do
      order = FactoryBot.create(:order, state: 'open')
      delete :destroy, params: { id: order.id }
      expect(flash[:notice]).to be_nil
      expect(flash[:alert]).to eq 'Error: no such order or quote'
      order.reload
      expect(order.open?).to be true
    end
  end

  context 'analyst user' do
    let(:user)  { FactoryBot.create(:analyst) }

    before(:each) do
      login(user)
    end

    it 'cannot submit an order' do
      order = FactoryBot.build(:order).as_json
      post :create, params: { order: order.as_json }
      expect(response.status).to eq(302)
      expect(flash[:alert]).to eq 'You are not allowed to perform that action.'
    end

    it 'cannot cancel an order' do
      order = FactoryBot.create(:order)
      delete :destroy, params: { id: order.id }
      expect(response.status).to eq(302)
      expect(flash[:alert]).to eq 'You are not allowed to perform that action.'
    end
  end
end
