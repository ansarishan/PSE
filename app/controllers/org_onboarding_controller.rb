class OrgOnboardingController < ApplicationController
  layout 'onboarding'

  STATES = [ # in order
    :new_org_admin,
    :user_agreement,
    :new_org,
    :new_legal,
    :new_trader,
    :new_analyst,
    :completed
  ]

  EULA = 'THIS TEXT IS PLACEHOLDER NONSENSE. NO WARRANTY EXCEPT AS EXPRESSLY SET FORTH IN THIS AGREEMENT, NEITHER RECIPIENT NOR ANY CONTRIBUTORS SHALL HAVE ANY LIABILITY FOR DEATH OR PERSONAL INJURY RESULTING FROM LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OR INABILITY TO USE THE COVERED CODE WILL BE LIABLE FOR ANY PARTICULAR PURPOSE OR THAT THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE PROGRAM (INCLUDING BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL ENTESSA, LLC, OPENSEAL OR ITS CONTRIBUTORS BE LIABLE FOR ANY INCIDENTAL, SPECIAL, EXTENDED, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITATION, CNRI MAKES NO REPRESENTATIONS OR WARRANTIES, EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE OR THAT THE OPERATION OF THE USE OF ANY KIND AND APPLE HEREBY DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS LICENSE ON AN "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED, INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES OR CONDITIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING, WITHOUT LIMITATION, WARRANTIES THAT THE FUNCTIONS CONTAINED IN THE COVERED CODE WILL BE CORRECTED. NO ORAL OR WRITTEN INFORMATION OR ADVICE GIVEN BY APPLE, AN APPLE AUTHORIZED REPRESENTATIVE OR ANY PORTION THEREOF, WHETHER UNDER A THEORY OF CONTRACT, WARRANTY, TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OR DISTRIBUTION OF THE SOFTWARE IS PROVIDED UNDER THE TERMS AND CONDITIONS OF MERCHANTABILITY, OF SATISFACTORY QUALITY, OF FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE PHP DEVELOPMENT TEAM AS IS AND ANY EXPRESS OR IMPLIED INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES OR CONDITIONS OF TITLE, NON-INFRINGEMENT, MERCHANTABILITY, OR FITNESS FOR A PARTICULAR PURPOSE.'

  def init
    reset_session
    invite = OnboardingInvite.find_by(url_code: params[:url_code])

    # TODO flash and redirect to home if invite.user.complete?

    unless invite
      render_error('Invalid or expired invitation.', 404) and return
    end

    session[:invite_id] = invite.id
    redirect_to action: start_state(invite).to_s
  end

  def new_org_admin
    if(invite = OnboardingInvite.find_by(id: session[:invite_id]))
      @user = User.new(email: invite.email, onboarding_invite: invite)
    else
      render_error('Invalid or expired invitation.', 404)
    end
  end

  def create_org_admin
    invite = OnboardingInvite.find_by!(id: session[:invite_id])
    @user = User.new(user_params)
    @user.role = 'org_admin'
    @user.onboarding_invite = invite
    @user.email = invite.email
    @user.organization = Organization.new
    if @user.save
      redirect_to action: next_state(:new_org_admin)
    else
      render action: :new_org_admin
    end
  end

  def user_agreement
    unless OnboardingInvite.find_by(id: session[:invite_id])
      render_error('Invalid or expired invitation.', 404)
    end
  end

  def signed_user_agreement
    invite = OnboardingInvite.find_by(id: session[:invite_id])
    raise "User doesn't exist yet" unless invite.user
    if params['agreement']['i_agree']=='1'
      invite.user.has_signed_eula = true
      invite.user.save!
      redirect_to action: next_state(:user_agreement)
    else
      @didnt_sign = true
      render action: 'user_agreement'
    end
  end

  def new_org
    invite = OnboardingInvite.find_by(id: session[:invite_id])
    unless invite
      render_error('Invalid or expired invitation.', 404) and return
    end
    unless invite.user
      redirect_to action: :new_org_admin and return
    end
    unless invite.user.has_signed_eula?
      redirect_to action: :user_agreement and return
    end

    @user = invite.user
    @user.build_address unless @user.address
  end

  def create_org
    invite = OnboardingInvite.find_by!(id: session[:invite_id])
    @user = invite.user

    # no hacking the org id!
    org_admin_params[:organization_attributes][:id] = @user.organization.id

    if @user.update(org_admin_params)
      redirect_to action: next_state(:new_org)
    else
      render action: :new_org
    end
  end

  def new_legal
    invite = OnboardingInvite.find_by(id: session[:invite_id])
    unless invite
      render_error('Invalid or expired invitation.', 404) and return
    end
    unless invite.user
      redirect_to action: :new_org_admin and return
    end
    unless invite.user.has_signed_eula?
      redirect_to action: :user_agreement and return
    end

    user = invite.user
    org = user.organization
    @legal_user = org.users.find_by(role: 'legal') || User.new
    @legal_user.build_address unless @legal_user.address
  end

  def create_legal
    invite = OnboardingInvite.find_by!(id: session[:invite_id])
    @org_admin = invite.user

    @legal_user = User.new(legal_user_params)
    @legal_user.role = :legal
    @legal_user.organization = @org_admin.organization

    if @legal_user.save
      redirect_to action: next_state(:new_legal)
    else
      render action: :new_legal
    end
  end

  def new_trader
    invite = OnboardingInvite.find_by(id: session[:invite_id])
    unless invite
      render_error('Invalid or expired invitation.', 404) and return
    end
    unless invite.user
      redirect_to action: :new_org_admin and return
    end
    unless invite.user.has_signed_eula?
      redirect_to action: :user_agreement and return
    end

    user = invite.user
    org = user.organization
    @trader_user = org.users.find_by(role: 'trader') || User.new
    @trader_user.build_address unless @trader_user.address
  end

  def create_trader
    invite = OnboardingInvite.find_by!(id: session[:invite_id])
    @org_admin = invite.user

    @trader_user = User.new(trader_user_params)
    @trader_user.role = :trader
    @trader_user.organization = @org_admin.organization

    if @trader_user.save
      redirect_to action: next_state(:new_trader)
    else
      render action: :new_trader
    end
  end

  def new_analyst
    invite = OnboardingInvite.find_by(id: session[:invite_id])
    unless invite
      render_error('Invalid or expired invitation.', 404) and return
    end
    unless invite.user
      redirect_to action: :new_org_admin and return
    end
    unless invite.user.has_signed_eula?
      redirect_to action: :user_agreement and return
    end

    user = invite.user
    org = user.organization
    @analyst_user = org.users.find_by(role: 'analyst') || User.new
    @analyst_user.build_address unless @analyst_user.address
  end

  def create_analyst
    if params['commit'].downcase.include?('skip')
      redirect_to action: :completed and return
    end

    invite = OnboardingInvite.find_by!(id: session[:invite_id])
    @org_admin = invite.user

    @analyst_user = User.new(analyst_user_params)
    @analyst_user.role = :analyst
    @analyst_user.organization = @org_admin.organization

    if @analyst_user.save
      redirect_to action: next_state(:new_analyst)
    else
      render action: :new_analyst
    end
  end

  def completed
    invite = OnboardingInvite.find_by!(id: session[:invite_id])
    unless invite
      render_error('Invalid or expired invitation.', 404) and return
    end
    unless invite.user
      redirect_to action: :new_org_admin and return
    end
    unless invite.user.has_signed_eula?
      redirect_to action: :user_agreement and return
    end

    invite.user.update!(onboarded: true)
  end

  private

  def render_error(message, status=404)
    @error_msg = message
    render template: 'org_onboarding/error', status: status
  end

  def start_state(invite)
    return :new_org_admin unless invite.user.present?
    return :user_agreement unless invite.user.has_signed_eula?
    return :complete if invite.user.onboarded?
    :new_org
  end

  def next_state(state)
    i = STATES.index(state)
    raise 'Invalid state' unless i
    return :completed if state==:completed
    STATES[i+1]
  end

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

  def org_admin_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone,
      organization_attributes: [:id, :name],
      address_attributes: [
        :line1, :line2, :city, :state, :postcode, :country
      ]
    )
  end

  def legal_user_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone, :legal_is_separate,
      address_attributes: [
        :line1, :line2, :city, :state, :postcode, :country
      ]
    )
  end

  def trader_user_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone,
      address_attributes: [
        :line1, :line2, :city, :state, :postcode, :country
      ]
    )
  end

  def analyst_user_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone,
      address_attributes: [
        :line1, :line2, :city, :state, :postcode, :country
      ]
    )
  end
end
