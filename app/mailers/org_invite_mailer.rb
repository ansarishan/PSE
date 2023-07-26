class OrgInviteMailer < ApplicationMailer
  SUBJECT = 'You have been invited to join PharmaShares!'

  def self.send_invite(onboarding_invite)
    OrgInviteMailer.with(onboarding_invite: onboarding_invite).invite.deliver_now
  end

  def invite
    @onboarding_invite = params[:onboarding_invite]
    mail(to: @onboarding_invite.email, subject: SUBJECT)
  end
end
