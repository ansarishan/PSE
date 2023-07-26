def expand_window_to_fit_book_and_ticket
  unless @expanded_window
    page.driver.browser.manage.window.resize_to(1600,1080)
    @expanded_window = true
  end
end

def verify_order_ticket_appeared
  expect(page).to have_selector('.orderTicket', visible: true)
end

def get_fosamax_instrument_for_ordinal(ordinal)
  words = ['first', 'second', 'third', 'fourth']
  idx = words.index(ordinal)
  raise "unsupported ordinal word '#{ordinal}'" if idx.nil?
  Drug.find_by(brand_name: 'Fosamax').drug_periods.first.drug_instruments.order(net_revenue_projection: :desc)[idx]
end

def get_new_net_revenue_projection(original_net_revenue_projection, plus_or_minus, premium_or_discount_percentage)
  premium_or_discount_percentage = premium_or_discount_percentage.to_d
  premium_or_discount_percentage *= -1 if plus_or_minus == '-'
  original_net_revenue_projection * ((100 + premium_or_discount_percentage).to_d / 100)
end

When /^I open the ([a-z]+)-side order ticket for the first-listed core contract$/ do |side|
  expand_window_to_fit_book_and_ticket
  idx = case side
    when 'up'; 0
    when 'down'; 1
  end
  all('.tradeButton')[idx].click

  verify_order_ticket_appeared
end

Then("I should not be able to open an order ticket") do
  expect(page).not_to have_css('.orderTicketPopper', visible: false)
end

When("I submit the order ticket with amount {int}") do |int|
  @active_drug_instrument = DrugInstrument.find(find('#order_drug_instrument_id', visible: false).value)
  find(:css, '#amountInputRow').find('input').set(int)
  click_button 'Submit'
end

When /^I submit the order ticket with amount (\d+) and net revenue projection of ([+-])(\d+)%$/ do |amount, plus_or_minus, premium_or_discount_percentage|
  @active_drug_instrument = DrugInstrument.find(find('#order_drug_instrument_id', visible: false).value)
  find(:css, '#amountInputRow').find('input').set(amount)
  find('#order_net_revenue_projection').set(get_new_net_revenue_projection(@active_drug_instrument.net_revenue_projection, plus_or_minus, premium_or_discount_percentage))
  click_button 'Submit'
end

Then /^the database should have an open ([a-z]+)-side order with amount (\d+) in a new instrument with net revenue projection of ([+-])(\d+)%$/ do |side, amount, plus_or_minus, premium_or_discount_percentage|
  orders = Order.where(side: side, amount: amount)
  expect(orders.count).to eq 1

  order = orders.first
  new_bespoke_drug_instrument = DrugInstrument.order(created_at: :desc).first
  new_net_revenue_projection = get_new_net_revenue_projection(@active_drug_instrument.net_revenue_projection, plus_or_minus, premium_or_discount_percentage)
  expect(new_bespoke_drug_instrument.net_revenue_projection).to eq(new_net_revenue_projection)
  expect(order.drug_instrument_id).to eq(new_bespoke_drug_instrument.id)
  expect(order.drug_instrument_id).not_to eq(@active_drug_instrument.id)
end

Then /^the database should have an open ([a-z]+)-side order with amount (\d+)$/ do |side, amount|
  expect(Order.where(side: side, amount: amount).count).to eq 1
end

Then /^I toggle the order ticket to trade the ([a-z]+)-side$/ do |side|
  find('button.toggler').click
end

Given /^I have an? ([a-z_]+) order with amount (\d+)$/ do |state, amount|
  FactoryBot.create(:order, state: state, amount: amount, organization: @active_user.organization)
end

Then /^I should see an order with amount (\d+)$/ do |amount|
  expand_window_to_fit_book_and_ticket
  expect(page).to have_css('td', text: amount)
end

Given /^my organization has an open (\w+) order for (\d+) in the (\w+) Fosamax instrument$/ do |side,amount,ordinal|
  @active_organization ||= FactoryBot.create(:organization)
  FactoryBot.create(:order, organization: @active_organization,
                            drug_instrument: get_fosamax_instrument_for_ordinal(ordinal),
                            side: side,
                            amount: amount)
end

Then /^there is an open (\w+) order for (\d+) in the first Fosamax instrument$/ do |side, amt|
  org = FactoryBot.create(:organization)
  FactoryBot.create(:lawyer, organization: org) #recipient for order-match email
  di = get_fosamax_instrument_for_ordinal('first')
  FactoryBot.create(:order, organization: org, drug_instrument: di, side: side, amount: amt)
end

When /^I use the UI to match the open (\w+) order$/ do |side|
  unless @active_user.organization.users.where(role: 'legal').exists?
    FactoryBot.create(:lawyer, organization: @active_user.organization) #recipient for order-match email
  end

  expand_window_to_fit_book_and_ticket
  other_side = side=='up' ? 'down' : 'up'
  button_td = first('tr.instrumentRow.tradeRow').first("td.#{other_side}.tradeButton")
  button_td.hover
  button_td.find('button.orderTicketPopper', text: "Match\nOrder").click
  verify_order_ticket_appeared

  click_button 'Submit'
end

Then /^the database should have my (\w+) (\w+) order for (\d+) and its (\w+) trade$/ do |ord_state, side, amt, trade_state|
  expect(Order.exists?(organization: @active_organization, side: side, amount: amt, state: ord_state)).to eq true
  expect(Trade.count).to eq 1
  expect(Trade.first.state).to eq trade_state
  expect(Order.count).to eq 2
  expect(Order.where(amount: amt).count).to eq 2
end

Then /^the database should( not)? have my open (\w+) order for (\d+)$/ do |negative,side,amt|
  order_exists = Order.exists?(organization: @active_organization, state: 'open', side: side, amount: amt)
  if negative
    expect(!order_exists)
  else
    expect(order_exists)
  end
end

When /^I click the cancel icon for the open (\w+) order$/ do |side|
  expand_window_to_fit_book_and_ticket
  actions_td = first('tr.instrumentRow.tradeRow').first("td.#{side}.actions")
  actions_td.hover
  actions_td.find('a.orderCancelIcon').click
  verify_confirm_modal_appeared
end

When("I click the cancel icon for the first-listed order") do
  all('.orderCancelIcon')[0].click
  # expand window so we can see the whole dialog
  page.driver.browser.manage.window.resize_to(1200,800)
end

Then("I should not be able to see order cancel icons") do
  expect(page).not_to have_css('.orderCancelIcon')
end

Then /^the database should not have any open orders$/ do
  expect(Order.open.count).to eq 0
end

