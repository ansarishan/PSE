def expand_window_to_fit_legal_ticket
  unless @expanded_window
    page.driver.browser.manage.window.resize_to(1600,800)
    @expanded_window = true
  end
end

Given /^I have an? (\w+) trade with amount (\d+)$/ do |trade_state, ord_amt|
  drug_inst = DrugInstrument.first
  ord_up = FactoryBot.create(:order, state: 'accepted', side: 'up',   amount: ord_amt, drug_instrument: drug_inst, organization: @active_organization)
  ord_dn = FactoryBot.create(:order, state: 'accepted', side: 'down', amount: ord_amt, drug_instrument: drug_inst, organization: FactoryBot.create(:organization))
  trade  = FactoryBot.create(:trade, state: 'unconfirmed', orders: [ord_up, ord_dn])
  if trade_state == 'unconfirmed'
  elsif trade_state == 'negotiating'
    ord_up.start_contract!
  elsif trade_state == 'maturing'
    ord_up.start_contract!
    ord_dn.start_contract!
    ord_up.confirm_contract!
    ord_dn.confirm_contract!
  else
    pending
  end
end

Then /^I should see a (\w+) order with trade state (\w+)$/ do |ord_state, trade_state|
  td = page.find(:css, 'td', text: trade_state.upcase)
  tr = td.find(:xpath, './parent::tr')
  expect(tr).to have_css('td', text: ord_state.upcase)
end

When /^I click the View link for the first (\w+) trade$/ do |trade_state|
  td = page.find(:css, 'td', text: trade_state.upcase)
  tr = td.find(:xpath, './parent::tr')
  tr.find_link('View').click
end

When /^I click (\w+) Contract$/ do |action|
  expand_window_to_fit_book_and_ticket
  click_button("#{action} Contract")
end

When /^the counterparty to my (\w+) order for (\d+) confirms the contract$/ do |side, amt|
  my_order = Order.find_by!(organization: @active_organization, side: side, amount: amt)
  counterparty_order = my_order.counterparty_order
  counterparty_order.start_contract! if counterparty_order.accepted?
  counterparty_order.confirm_contract!
end

Then /^the database should have my counterparty's (\w+) (\w+) order for (\d+) and its (\w+) trade/ do |ord_state, side, amt, trade_state|
  my_side = side == 'up' ? 'down' : 'up'
  my_order = Order.find_by!(organization: @active_organization, side: my_side, amount: amt)
  counterparty_order = my_order.counterparty_order
  expect(counterparty_order.state).to eq(ord_state)
  expect(counterparty_order.side).to eq(side)
  expect(counterparty_order.amount).to eq(amt)
  expect(counterparty_order.trade.maturing?)
end

Then("the lawyers on each side of the trade should receive new-order-notification emails") do
  expect(ActionMailer::Base.deliveries.count).to eq 2
  expect(ActionMailer::Base.deliveries[0].subject).to eq 'Please review this trade'
  expect(ActionMailer::Base.deliveries[1].subject).to eq 'Please review this trade'
end
