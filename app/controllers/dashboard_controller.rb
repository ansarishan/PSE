class DashboardController < LoggedInController
  def index
    @sidemenu = { regions: Region.data_for_side_menu } if current_user.trader? || current_user.analyst?
    
    @is_ss = Region.drug_companies_ss(current_user.organization_id)
  end
end
