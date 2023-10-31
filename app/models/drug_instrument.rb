class DrugInstrument < ApplicationRecord
  belongs_to :drug_period, inverse_of: :drug_instruments
  has_many :orders, inverse_of: :drug_instrument, dependent: :nullify
  has_many :quotes, inverse_of: :drug_instrument, dependent: :nullify
  has_many :tradables, inverse_of: :drug_instrument, dependent: :nullify

  validates :up_leverage_factor, presence: true
  validates :up_leverage_factor, numericality: { greater_than: 0 }, allow_blank: true
  validates :down_leverage_factor, presence: true
  validates :down_leverage_factor, numericality: { greater_than: 0 }, allow_blank: true
  validates :up_return_cap, presence: true
  validates :up_return_cap, numericality: { greater_than: 0 }, allow_blank: true
  validates :down_return_cap, presence: true
  validates :down_return_cap, numericality: { greater_than: 0 }, allow_blank: true
  validates :net_revenue_projection, presence: true
  validates :net_revenue_projection, numericality: { greater_than: 0 }, allow_blank: true

  delegate :net_revenue_actual, :status, :region, to: :drug_period

  def display_name
    debug_name
  end

  def debug_name
    "#{drug_period.drug.brand_name}[#{drug_period.label}]--#{terms_to_s}"
  end

  def terms_to_s
    "#{up_leverage_factor}x:#{up_return_cap}%" +
      "|#{net_revenue_projection}|" +
      "#{down_leverage_factor}x:#{down_return_cap}%"
  end

  def up_open_vol
    orders.where(state: 'open', side: 'up').sum(:amount)
  end

  def down_open_vol
    orders.where(state: 'open', side: 'down').sum(:amount)
  end

  def closed_vol
    orders.includes(:trade).
      where(side: 'up').
      where('trades.state = ?', Trade.states['maturing']).
      references(:trades).
      sum(:amount)
  end

  def self.find_or_create_bespoke_by!(orig_drug_instrument, attrs)
    DrugInstrument.find_or_create_by!(
      drug_period_id:         attrs[:drug_period_id] || orig_drug_instrument.drug_period_id,
      net_revenue_projection: attrs[:net_revenue_projection] || orig_drug_instrument.net_revenue_projection,
      up_leverage_factor:     attrs[:up_leverage_factor] || orig_drug_instrument.up_leverage_factor,
      up_return_cap:          attrs[:up_return_cap] || orig_drug_instrument.up_return_cap,
      down_leverage_factor:   attrs[:down_leverage_factor] || orig_drug_instrument.down_leverage_factor,
      down_return_cap:        attrs[:down_return_cap] || orig_drug_instrument.down_return_cap,
      notes:        attrs[:notes] || orig_drug_instrument.notes
    ) do |di|
      di.label = "Bespoke Contract / #{Time.now.to_s(:drug_instrument_date)}"
    end
  end
end
