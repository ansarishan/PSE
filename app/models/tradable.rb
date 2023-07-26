class Tradable < ApplicationRecord
  belongs_to :drug_instrument, inverse_of: :orders, optional: false
  belongs_to :organization, inverse_of: :orders, optional: false
  has_one :drug_period, through: :drug_instrument

  enum state: {
    open: 0,
    accepted: 10,       # matched, but legal has not seen it
    declined: 15,       # receiver has declined a quote
    legal_working: 20,  # legal has seen it
    legal_approved: 30, # legal has approved it
    canceled: 40,
    expired: 50         # period ended without this being matched
  }

  enum side: {
    up: 0,
    down: 1
  }

  validates :amount, presence: true
  validates :amount, numericality: { greater_than: 0 }, allow_blank: true
  validate :amount_step_size
  validates :state, presence: true
  validates :side, presence: true

  def as_json(options = {})
    super(options.merge(methods: :type))
  end

  def counter_order
    Order.find(self.counter_order_id)
  end

  def counter_organization
    Order.find(self.counter_order_id).organization
  end

  def other_side
    side=='up' ? 'down' : 'up'
  end

  def display_name
    "#{drug_instrument.display_name}-#{organization.name}-#{side}-#{amount}-#{state}"
  end

  def my_terms; terms_for_side(side); end
  def their_terms; terms_for_side(other_side); end

  def terms_for_side(side)
    side=='up' ?
      { lev: drug_instrument.up_leverage_factor, cap: drug_instrument.up_return_cap } :
      { lev: drug_instrument.down_leverage_factor, cap: drug_instrument.down_return_cap }
  end

  def cancel
    if self.open?
      self.update(state: 'canceled')
    else
      errors.add(:order, "Too late too cancel")
      false
    end
  end

  def above_or_below
    Tradable.side_to_above_or_below(side) # returns "above" or "below"
  end

  def self.side_to_above_or_below(side)
    side=='up' ? 'above' : 'below'
  end

  def self.org_can_trade?(tradable)
    !Tradable.exists?(type: tradable.type, side: tradable.other_side, state: 'open', organization: tradable.organization, drug_instrument_id: tradable.drug_instrument_id)
  end

  protected

  def amount_step_size
    return if amount.blank?
    return if amount < 0
    errors.add(:amount, 'must be an increment of 50') unless amount % 50.0 == 0
  end
end
