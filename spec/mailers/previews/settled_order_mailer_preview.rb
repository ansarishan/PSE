# Preview all emails at http://localhost:3000/rails/mailers/settled_order_mailer
class SettledOrderMailerPreview < ActionMailer::Preview
  def notify
    trade1 = FactoryBot.create(:trade)
    trade1.orders.first.drug_instrument.drug_period.update(status: 'expired', net_revenue_actual: 1.23)
    FactoryBot.create(:trader, organization: trade1.orders.first.organization, first_name: 'Frank', last_name: 'Castle')
    SettledOrderMailer.with(order: trade1.orders.first).notify
  end
end
