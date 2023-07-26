require "rails_helper"

RSpec.describe NewOrderLegalReviewMailer, type: :mailer do
  describe 'notify' do
    let(:lawyer) { FactoryBot.create(:lawyer) }
    let(:order) { FactoryBot.create(:order, organization: lawyer.organization) }
    let(:mail) { NewOrderLegalReviewMailer.with(order: order).notify }

    it 'renders the headers' do
      expect(mail.subject).to eq 'Please review this trade'
      expect(mail.to).to eq [lawyer.email]
      expect(mail.from).not_to be_nil
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match 'An order match has been proposed for the following contract'
    end
  end
end
