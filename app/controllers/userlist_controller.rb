class UserlistController < LoggedInController
  before_action :check_role

  def index
  end

  private

  def check_role
    return if current_user.admin?
    redirect_to dashboard_path, alert: 'You are not allowed to perform that action.'
  end
end
