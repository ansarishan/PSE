require "rails_helper"

RSpec.describe SettledOrderMailer, type: :mailer do
  describe 'notify' do
    let(:trade) do
      tr = FactoryBot.create(:trade)
      tr.orders.first.drug_instrument.drug_period.update(status: 'expired', net_revenue_actual: 1.23)
      tr
    end
    let!(:trader) { FactoryBot.create(:trader, organization: trade.orders.first.organization) }
    let(:mail) { SettledOrderMailer.with(order: trade.orders.first).notify }

    it 'renders the headers' do
      expect(mail.subject).to eq 'Your trade has settled'
      expect(mail.to).to eq [trader.email]
      expect(mail.from).not_to be_nil
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match 'has settled with a revenue announcement of 1.23 million'
    end
  end
end
