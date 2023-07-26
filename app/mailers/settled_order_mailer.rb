class SettledOrderMailer < ApplicationMailer
  def self.send_trade_notifications(trade)
    trade.orders.each do |ord|
      SettledOrderMailer.with(order: ord).notify.deliver_now
    end
  end

  def notify
    @order = params[:order]
    @trader = @order.organization.users.find_by(role: 'trader')
    @drug_period = @order.drug_instrument.drug_period

    mail(to: @trader.email, subject: 'Your trade has settled')
  end
end
