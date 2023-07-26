class Order < Tradable
  belongs_to :trade, inverse_of: :orders, optional: true

  scope :trade_pending, -> {
    includes(:trade).where('trades.state': ['unconfirmed', 'negotiating'])
  }
  scope :trade_maturing, -> {
    includes(:trade).where('trades.state': ['maturing'])
  }
  scope :trade_settled, -> {
    includes(:trade).where('trades.state': ['settled'])
  }
  scope :trade_canceled_or_expired, -> {
    includes(:trade).where('trades.state': ['canceled', 'expired'])
  }

  def pnl
    if self.up?
      self.trade&.upside_gain
    elsif self.trade&.upside_gain
      -1 * self.trade&.upside_gain
    else
      nil
    end
  end

  def self.states_humanized
    Order.states.keys.inject({}) do |h, item|
      h[item] = item.humanize.split.map(&:capitalize).join(' ')
      h
    end
  end

  def self.settle_for_drug_period(dp_or_id)
    dpid = dp_or_id.is_a?(Integer) ? dp_or_id : dp_or_id.id

    Order.joins(drug_instrument: :drug_period)
         .where(drug_periods: { id: dpid })
         .where(state: 'open')
         .update(state: 'expired')
  end

  def counterparty_order
    self.trade&.counterparty_order(self.organization_id)
  end

  def start_contract!
    raise "Cannot Start Contract unless your Order State is Accepted" unless self.accepted?

    ActiveRecord::Base.transaction do
      self.update!(state: 'legal_working')
      self.trade.update!(state: 'negotiating') if self.trade.unconfirmed?
    end
  end

  def confirm_contract!
    raise "Cannot Confirm Contract unless your Order State is Legal Working" unless self.legal_working?

    ActiveRecord::Base.transaction do
      self.update!(state: 'legal_approved')
      self.trade.update!(state: 'maturing') if self.counterparty_order.legal_approved?
    end
  end

  def cancel_contract!
    raise "Cannot Cancel Contract unless Trade State is Unconfirmed or Negotiating" unless (self.trade.unconfirmed? || self.trade.negotiating?)

    ActiveRecord::Base.transaction do
      self.update!(state: 'canceled')
      self.counterparty_order.update!(state: 'canceled')
      self.trade.update(state: 'canceled')
    end
  end
end
