class TradablesController < LoggedInController
  before_action :check_trader_role, :check_org, except: [:start_contract, :confirm_contract, :cancel_contract, :edit]
  before_action :check_legal_role,  :check_org, only:   [:start_contract, :confirm_contract, :cancel_contract, :edit]

  def create
    orig_drug_instrument = DrugInstrument.find_by(id: params[:order][:drug_instrument_id])
    drug_instrument = DrugInstrument.find_or_create_bespoke_by!(orig_drug_instrument, params[:order])
    @tradable = Tradable.new(order_params.merge(drug_instrument_id: drug_instrument.id))
    @tradable.organization = current_user.organization
    @tradable.state = 'open'

    if Tradable.org_can_trade?(@tradable) == false
      flash[:alert] = "#{@tradable.type} refused; your organization cannot have open #{@tradable.type.downcase.pluralize} on both sides of a contract."

    elsif @tradable.drug_instrument.drug_period.open? == false
      flash[:alert] = "#{@tradable.type} refused; this contract period is not open."

    elsif (params[:order][:counter_order_id].to_i) > 0 && (params[:order][:type] == 'Order')
      if !@tradable.valid?
        items = @tradable.errors.to_a.collect {|err| "<li>#{err}"}
        flash[:alert] = "Errors creating #{@tradable.type.downcase}:<ul>#{items.join("\n")}"

      else
        result = Trade.make_a_match(@tradable, params['order']['counter_order_id'])
        if result[:success]
          flash[:notice] = "#{@tradable.type} match created."
        elsif result[:errors]
          items = result[:errors].collect {|err| "<li>#{err}"}
          flash[:alert] = "Errors creating matching #{@tradable.type.downcase}:<ul>#{items.join("\n")}"
        end
      end

    else
      if @tradable.save
        flash[:notice] = "#{@tradable.type} created."
      else
        items = @tradable.errors.to_a.collect {|err| "<li>#{err}"}
        flash[:alert] = "Errors creating #{@tradable.type.downcase}:<ul>#{items.join("\n")}"
      end
    end

    redirect_to book_path(@tradable.drug_instrument.drug_period_id)
  end

  def destroy
    @tradable = current_user.organization.tradables.find(params[:id])
    if @tradable.cancel
      flash[:notice] = "#{@tradable.type} canceled."
    else
      flash[:alert] = 'Error: ' + @tradable.errors.join("\n");
    end
  rescue ActiveRecord::RecordNotFound
      flash[:alert] = "Error: no such order or quote"
  ensure
    redirect_back fallback_location: dashboard_url
  end

  def start_contract
    @order = current_user.organization.orders.find(params[:order_id])
    @order.start_contract!
  rescue => e
    flash[:alert] = e.message
  else
    flash[:notice] = 'Contract started.'
  ensure
    redirect_back fallback_location: dashboard_url
  end

  def confirm_contract
    @order = current_user.organization.orders.find(params[:order_id])
    @order.confirm_contract!
  rescue => e
    flash[:alert] = e.message
  else
    flash[:notice] = 'Contract confirmed.'
  ensure
    redirect_back fallback_location: dashboard_url
  end

  def cancel_contract
    @order = current_user.organization.orders.find(params[:order_id])
    @order.cancel_contract!
  rescue => e
    flash[:alert] = e.message
  else
    flash[:notice] = 'Contract canceled.'
  ensure
    redirect_back fallback_location: dashboard_url
  end

  def edit
    @order = current_user.organization.orders.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  private

  def order_params
    params.require(:order).permit(:type, :drug_instrument_id, :amount, :side, :counter_order_id)
  end

  def check_legal_role
    unless current_user.legal?
      redirect_back fallback_location: dashboard_url, alert: 'You are not allowed to perform that action.'
    end
  end

  def check_trader_role
    unless current_user.role=='trader'
      bookid = params.dig('order', 'drug_instrument_id')
      path = bookid ? book_path(bookid) : dashboard_path
      redirect_to path, alert: 'You are not allowed to perform that action.'
    end
  end

  def check_org
    if current_user.organization.nil?
      redirect_to dashboard_path, alert: 'You cannot do this because you have no organization.'
    end
  end
end
