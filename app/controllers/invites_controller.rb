class InvitesController < LoggedInController
  before_action :reject_non_admins

  def index
    @open_invites = []
    # TODO do a join query that is actually efficient
    OnboardingInvite.all.each do |oi|
      @open_invites << oi unless oi.user.try(:onboarded?)
    end
  end

  def new
    @invite = OnboardingInvite.new
  end

  def create
    email = params[:onboarding_invite][:email]
    if(OnboardingInvite.find_by(email: email))
      @invite = OnboardingInvite.new
      flash[:alert] = "Email '#{email}' has already been invited."
      render action: :new
    end

    @invite = OnboardingInvite.new(email: email,
                                   url_code: OnboardingInvite.generate_url_code)
    if @invite.save
      OrgInviteMailer.send_invite(@invite)
      flash[:notice] = "Invite to '#{email}' has been sent."
      redirect_to action: :index
    else
      render action: :new
    end
  end

  private

  def reject_non_admins
    if current_user.role != 'admin'
      flash[:alert] = 'You are not allowed to perform this action.'
      redirect_to dashboard_path
    end
  end
end

