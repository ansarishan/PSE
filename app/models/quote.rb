class Quote < Tradable
  def decline
    if self.open?
      self.update(state: 'declined')
    else
      errors.add(:order, "Too late too decline")
      false
    end
  end

  def self.states_humanized
    Quote.states.keys.inject({}) do |h, item|
      h[item] = item.humanize.split.map(&:capitalize).join(' ')
      h
    end
  end

  def self.org_can_trade?(quote)
    !Quote.exists?(side: quote.other_side, state: 'open', organization: quote.organization, drug_instrument_id: quote.drug_instrument_id)
  end
end
