Given /^I open the calculator$/ do
  click_button 'Calculator'
end

Given /^this test creates a Fosamax instrument with projection=([^ ]+)$/ do |proj|
  usa_region = Region.find_or_create_by!(name: 'USA')
  merck = DrugCompany.find_or_create_by!(name: 'Merck & Co., Inc')
  fosamax = Drug.find_or_create_by!(brand_name: 'Fosamax', drug_company: merck)
  fosa1 = DrugPeriod.find_or_create_by!(drug: fosamax, label: 'Q119 - Q219', period_type: 'Quarterly', status: 'open', region: usa_region)
  DrugInstrument.find_or_create_by!(drug_period: fosa1, net_revenue_projection: proj,
    up_leverage_factor: 2, down_leverage_factor: 3,
    up_return_cap: 30, down_return_cap: 40)
end

When /^I enter calculator params revenue=([^ ]+) amount=([^ ]+) upLev=([^ ]+) upCap=([^ ]+) downCap=([^ ]+) downLev=([^ ]+)$/ do |revenue, amount, up_lev, up_cap, down_cap, down_lev|
  find('input[data-target="calculator.examplePeriodRevenue"]').set(revenue)
  find('input[data-target="calculator.tradingAmount"]').set(amount)
  find('input[data-target="calculator.aboveLeverage"]').set(up_lev)
  find('input[data-target="calculator.aboveReturnCap"]').set(up_cap)
  find('input[data-target="calculator.belowLeverage"]').set(down_lev)
  find('input[data-target="calculator.belowReturnCap"]').set(down_cap)

  # just click on something to move focus off the input and cause JS to react
  find('div[data-target="calculator.maxReturn"]').click
end

Then /^I should see calculator results maxReturn=([^ ]+) maxLoss=([^ ]+) totalRoL=([^ ]+)$/ do |max_return, max_loss, total_rol|
  expect(find('div[data-target="calculator.maxReturn"]').text).to eq max_return
  expect(find('div[data-target="calculator.maxLoss"]').text).to eq max_loss
  expect(find('div[data-target="calculator.totalReturnOrLoss"]').text).to eq total_rol
end

Then /^I toggle the calculator side to (\w+)$/ do |side|
  raise unless ['up','down'].include?(side.downcase)
  side = side.downcase

  # the actual toggle input is hidden; the label is the exposed element that takes the click
  # (HTML toggles are hard to style; this is what you have to do.)

  toggle = find('input#calcSideToggleSwitch', visible: false) # checked==down
  toggle_label = find('label.toggleswitch-label')

  if side=='up'
    toggle_label.click if toggle.checked?
  else
    toggle_label.click unless toggle.checked?
  end
end
