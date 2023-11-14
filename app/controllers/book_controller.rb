class BookController < LoggedInController
  before_action :check_role

  def index
    @drug_period = DrugPeriod.find_by(id: params[:drug_period_id])
    @is_ss = Region.drug_companies_ss(current_user.organization_id)
    if @drug_period.nil?
      # TODO log what url did this
      redirect_to dashboard_path, alert: 'That URL does not point to a valid instrument.'
    end
    @sidemenu = { regions: Region.data_for_side_menu } 
  end

  private

  def check_role
    unless %w[trader analyst].include?(current_user.role)
      redirect_to dashboard_path, alert: 'You are not allowed to perform that action.'
    end
  end
end
