# Preview all emails at http://localhost:3000/rails/mailers/org_invite_mailer
class OrgInviteMailerPreview < ActionMailer::Preview
  def invite
    oi = FactoryBot.build(:onboarding_invite,
      email: 'burtreynolds@example.com',
      url_code: 'wooooooo')
    OrgInviteMailer.with(onboarding_invite: oi).invite
  end
end
