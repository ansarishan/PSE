require "rails_helper"

RSpec.describe OrgInviteMailer, type: :mailer do
  describe 'invite' do
    let(:oi) { FactoryBot.create(:onboarding_invite) }
    let(:mail) { OrgInviteMailer.with(onboarding_invite: oi).invite }

    it 'renders the headers' do
      expect(mail.subject).to eq OrgInviteMailer::SUBJECT
      expect(mail.to).to eq [oi.email]
      expect(mail.from).not_to be_nil
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match("You have been invited")
      expect(mail.body.encoded).to match(oi.invite_url)
    end
  end
end
