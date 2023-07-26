class DashboardController < LoggedInController
  def index
    @sidemenu = { regions: Region.data_for_side_menu } if current_user.trader? || current_user.analyst?
  end
end
