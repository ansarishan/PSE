class Trade < ApplicationRecord
  has_many :orders, inverse_of: :trade, dependent: :nullify

  enum state: {
    unconfirmed: 0,  # neither legal has started review
    negotiating: 10, # one legal has started review
    maturing: 20,    # both legals have approved
    settled: 30,
    expired: 40,     # period ended before both legals approved
    canceled: 50     # one legal has canceled
  }

  validates :state, presence: true
  validate :exactly_2_orders
  validate :above_and_below
  validate :equal_amounts
  validate :same_instrument
  validate :settled_with_upside_gain

  def above
    orders.find_by(side: 'up')
  end

  def below
    orders.find_by(side: 'down')
  end

  def calculate_upside_gain
    di = orders.first.drug_instrument
    actual = di.drug_period.net_revenue_actual
    raise 'missing DrugPeriod.net_revenue_actual' unless actual

    projection = di.net_revenue_projection
    amount = orders.first.amount

    Trade.calculate_upside_gain(
      actual,
      di.net_revenue_projection,
      orders.first.amount,
      di.up_leverage_factor,
      di.up_return_cap,
      di.down_leverage_factor,
      di.down_return_cap)
  end

  def self.calculate_upside_gain(actual, projection, amount, up_lev, up_cap, down_lev, down_cap)
    percent_change = (actual - projection) / projection.to_f
    is_up = percent_change > 0

    lev = percent_change.abs * (is_up ? up_lev : down_lev)
    cap = (is_up ? up_cap : down_cap) / 100.0

    rol = [lev,cap].min * amount * 1000.0
    rol * (is_up ? 1 : -1)
  end

  def self.make_a_match(unsaved_order, counter_order_or_counter_order_id)
    # if success, return { success: trade }
    # if error, return { errors: [msgs] }

    o1 = if counter_order_or_counter_order_id.is_a?(Order)
           counter_order_or_counter_order_id
         else
           Order.find_by(id: counter_order_or_counter_order_id)
         end

    return { errors: ['Counter-order is not open'] } unless o1.open?
    o1.state = 'accepted'
    return { errors: o1.errors.to_a } unless o1.save

    o2 = unsaved_order
    o2.state = 'accepted'
    return { errors: o2.errors.to_a } unless o2.save

    trade = Trade.new(state: 'unconfirmed')
    trade.orders << o1
    trade.orders << o2
    return { errors: trade.errors.to_a } unless trade.save

    NewOrderLegalReviewMailer.send_trade_notifications(trade)

    { success: trade }
  end

  def self.for_drug_period(dp_or_id, wherehash={})
    dpid = dp_or_id.is_a?(Integer) ? dp_or_id : dp_or_id.id

    # This is horribly inefficient and will need work later.
    # (Suggestion: change has_many/orders to belongs_to/maker & belongs_to/taker)
    #
    # It's hideous, actually.

    Trade.where(wherehash).to_a.select {|tr| tr.orders.first.drug_instrument.drug_period_id == dpid }
  end

  def self.settle_for_drug_period(dp_or_id)
    trade_array = Trade.for_drug_period(dp_or_id)

    trade_array.each do |tr|
      if tr.maturing?
        tr.update!(state: 'settled', upside_gain: tr.calculate_upside_gain)
        SettledOrderMailer.send_trade_notifications(tr)
      elsif tr.unconfirmed? || tr.negotiating?
        tr.update!(state: 'expired')
        tr.orders.update(state: 'expired')
      end
    end
  end

  def counterparty_order(my_organization_id)
    self.orders.where.not(organization_id: my_organization_id).first
  end

  private

  def exactly_2_orders
    errors.add(:orders, 'must have exactly 2 Orders') if orders.to_a.count != 2
  end

  def above_and_below
    return if orders.to_a.count != 2
    errors.add(:orders, 'must have 1 Above order and 1 Below order') if orders[0].side==orders[1].side
  end

  def settled_with_upside_gain
    return if upside_gain.present?
    errors.add(:upside_gain, 'must be set if state=settled') if state=='settled'
  end

  def equal_amounts
    return if orders.to_a.count != 2
    errors.add(:orders, 'must have equal amounts') unless orders[0].amount == orders[1].amount
  end

  def same_instrument
    return if orders.to_a.count != 2
    errors.add(:orders, 'must have the same drug_instrument') unless orders[0].drug_instrument == orders[1].drug_instrument
  end
end
