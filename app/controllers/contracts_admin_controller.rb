class ContractsAdminController < LoggedInController
  before_action :check_role

  def index
  end

  def open
    dp = DrugPeriod.find_by(id: params['drug_period_id'])
    if dp.expired?
      flash[:alert] = "You can't open or close an expired period."
      redirect_to action: :index
    end
    dp.status = 'open'
    dp.save!
    redirect_to action: :index
  end

  def close
    dp = DrugPeriod.find_by(id: params['drug_period_id'])
    if dp.expired?
      flash[:alert] = "You can't open or close an expired period."
      redirect_to action: :index
    end
    dp.status = 'closed'
    dp.save!
    redirect_to action: :index
  end

  def expire_form
    @drug_period = DrugPeriod.find_by(id: params['drug_period_id'])
    if @drug_period.expired?
      flash[:alert] = 'Period is already expired'
      redirect_to action: index
    end
  end

  def expire
    drug_period = DrugPeriod.find(params[:drug_period_id])
    if drug_period.expired?
      flash[:alert] = 'Period is already expired'
      redirect_to action: index
    end
    drug_period.update!( expire_params.merge({status: 'expired'}) )

    Trade.settle_for_drug_period(drug_period)
    Order.settle_for_drug_period(drug_period)

    redirect_to action: :index
  end

  private

  def check_role
    return if current_user.admin?
    redirect_to dashboard_path, alert: 'You are not allowed to perform that action.'
  end

  def expire_params
    params.require(:drug_period).permit(:net_revenue_actual)
  end
end

