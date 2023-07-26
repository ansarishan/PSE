class NewOrderLegalReviewMailer < ApplicationMailer
  def self.send_trade_notifications(trade)
    trade.orders.each do |order|
      NewOrderLegalReviewMailer.with(order: order).notify.deliver_now
    end
  end

  def notify
    @order = params[:order]
    @lawyer = @order.organization.users.find_by(role: 'legal')

    if @lawyer
      mail(to: @lawyer.email, subject: 'Please review this trade')
    else
      logger.error("Could not find a legal user to notify for organization id=#{@order.organization.id} (#{@order.organization.name})")
    end
  end

end
