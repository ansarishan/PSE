class QuotesController < TradablesController
  before_action :check_trader_role, :check_org

  def destroy
    @quote = current_user.organization.quotes.find(params[:id])
    if @quote.cancel
      flash[:notice] = "#{@quote.type} canceled."
    else
      flash[:alert] = 'Error: ' + @quote.errors.join("\n");
    end
  rescue ActiveRecord::RecordNotFound
      flash[:alert] = "Error: no such order or quote"
  ensure
    redirect_back fallback_location: dashboard_url
  end

  def decline
    @quote = current_user.organization.received_quotes.find(params[:quote_id])
    if @quote.decline
      flash[:notice] = "#{@quote.type} declined."
    else
      flash[:alert] = 'Error: ' + @quote.errors.join("\n");
    end
  rescue ActiveRecord::RecordNotFound
      flash[:alert] = "Error: no such order or quote"
  ensure
    redirect_back fallback_location: dashboard_url
  end

  # TODO: refactor with OrdersController#create
  def accept
    ActiveRecord::Base.transaction do
      @quote = current_user.organization.received_quotes.find(params[:quote_id])
      @order         = Order.create(state: 'open', drug_instrument_id: @quote.drug_instrument_id, amount: @quote.amount, side: @quote.other_side, organization: current_user.organization)
      @counter_order = Order.create(state: 'open', drug_instrument_id: @quote.drug_instrument_id, amount: @quote.amount, side: @quote.side, organization: @quote.organization)

      @order.counter_order_id = @counter_order.id
      @order.save!
      @counter_order.counter_order_id = @order.id
      @counter_order.save!

      if Tradable.org_can_trade?(@order) == false
        flash[:alert] = "Order refused; your organization cannot have open orders on both sides of a contract."
      elsif @order.drug_instrument.drug_period.open? == false
        flash[:alert] = "Order refused; this contract period is not open."
      else
        if !@order.valid?
          items = @order.errors.to_a.collect {|err| "<li>#{err}"}
          flash[:alert] = "Errors creating order:<ul>#{items.join("\n")}"
        else
          result = Trade.make_a_match(@order, @counter_order)
          if result[:success]
            flash[:notice] = "Order match created."
          elsif result[:errors]
            items = result[:errors].collect {|err| "<li>#{err}"}
            flash[:alert] = "Errors creating matching order:<ul>#{items.join("\n")}"
          end
        end
      end
    end

    redirect_back fallback_location: dashboard_url
  end
end
