Given("I visit the admin contract list") do
  visit contracts_admin_path
end

def get_dpid_from_form
  idstr = page.find('form')['id']
  (idstr.match /\w*_(\d+)$/)[1].to_i
end

When /^I expire the first drug period, specifying actual net revenue "(\d+)"$/ do |n|
  click_link_or_button 'Expire this market'
  anticipate(interval: 0.1, attempts: 10) do
    expect(page).to have_content('Expire a Drug Period')
  end

  puts "WARNING: overwriting @selected_period" if @selected_period
  @selected_period = DrugPeriod.find(get_dpid_from_form)

  fill_in 'drug_period_net_revenue_actual', with: n
  click_button 'Expire the Period'
end

Then /^the DB should have recorded that period as being expired with net revenue "(\d+)"$/ do |n|
  @selected_period.reload
  expect(@selected_period.status).to eq 'expired'
  expect(@selected_period.net_revenue_actual).to eq n.to_i
end

Given /^the test gives this drug period (\d+) maturing trades?$/ do |n|
  n.to_i.times do
    o1 = FactoryBot.create(:order, side: 'up', state: 'legal_approved', drug_instrument: @last_created_drug_period.drug_instruments.first)
    o2 = FactoryBot.create(:order, side: 'down', state: 'legal_approved', drug_instrument: @last_created_drug_period.drug_instruments.first)
    [o1,o2].each do |ord|
      FactoryBot.create(:trader, organization: ord.organization) unless User.trader.where(organization: ord.organization).exists?
    end
    FactoryBot.create(:trade, state: 'maturing', orders: [o1, o2])
  end
end

Given /^the test gives this drug period (\d+) in-negotiation trades?$/ do |n|
  n.to_i.times do
    o1 = FactoryBot.create(:order, side: 'up', state: 'legal_working', drug_instrument: @last_created_drug_period.drug_instruments.first)
    o2 = FactoryBot.create(:order, side: 'down', state: 'legal_working', drug_instrument: @last_created_drug_period.drug_instruments.first)
    FactoryBot.create(:trade, state: 'negotiating', orders: [o1, o2])
  end
end

Given /^the test gives this drug period (\d+) open order$/ do |n|
  FactoryBot.create(:order, side: 'up', state: 'open', drug_instrument: @last_created_drug_period.drug_instruments.first)
end

Then /^this drug period should have (\d+) settled trades? with settlement values recorded$/ do |n|
  trades_array = Trade.for_drug_period(@selected_period, state: 'settled')
  expect(trades_array.count).to eq n
  expect(trades_array.all? {|tr| tr.upside_gain.present? }).to eq true
end

Then /^the system should have sent (\d+) settlement emails?$/ do |n|
  expect(ActionMailer::Base.deliveries.count).to eq 2
  expect(ActionMailer::Base.deliveries[0].subject).to eq 'Your trade has settled'
  expect(ActionMailer::Base.deliveries[1].subject).to eq 'Your trade has settled'
end

Then /^this drug period should have (\d+) expired trades?$/ do |n|
  expect(Trade.for_drug_period(@selected_period, state: 'expired').count).to eq n
end

Then /^this drug period should have (\d+) expired orders?$/ do |n|
  orders = []
  @selected_period.drug_instruments.each do |di|
    orders += di.orders.where(state: 'expired').to_a
  end
  expect(orders.count).to eq n
end

