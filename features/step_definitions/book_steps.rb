Given(/^this test creates Fosamax instruments$/) do
  usa_region = Region.find_or_create_by!(name: 'USA')

  merck = DrugCompany.find_or_create_by!(name: 'Merck & Co., Inc')

  fosamax = Drug.find_or_create_by!(brand_name: 'Fosamax', drug_company: merck)
  fosa1 = DrugPeriod.find_or_create_by!(drug: fosamax, label: 'Q119 - Q219', period_type: 'Quarterly', status: 'open', region: usa_region)

  DrugInstrument.find_or_create_by!(drug_period: fosa1, net_revenue_projection: 8.5,
    up_leverage_factor: 2, down_leverage_factor: 3,
    up_return_cap: 30, down_return_cap: 40)
  DrugInstrument.find_or_create_by!(drug_period: fosa1, net_revenue_projection: 9,
    up_leverage_factor: 2, down_leverage_factor: 3,
    up_return_cap: 30, down_return_cap: 40)
end

Given /^the test creates a drug period that is (\w+)$/ do |status|
  step "this test creates Fosamax instruments"
  # if this raises, the above step might have changed in a way you don't want
  raise 'please review/update this step' if DrugPeriod.count > 1
  DrugPeriod.first.update(status: status)
  @last_created_drug_period = DrugPeriod.first
end

And(/^I visit the first Fosamax book$/) do
  drug_period = Drug.find_by!(brand_name: 'Fosamax').drug_periods.first
  visit "/book/#{drug_period.id}"
end

Then /^I should see the first Fosamax book$/ do
  drug_period = Drug.find_by!(brand_name: 'Fosamax').drug_periods.first
  expect(page).to have_css('.bookContainer')
  expect(page).to have_css('h1', text: drug_period.drug.drug_company.name)
  expect(page).to have_css('h1', text: drug_period.drug.brand_name)
  expect(page).to have_css('h1', text: drug_period.period_type)
end

def find_core_row_idx(i, rows)
  count = -1
  rows.each_with_index do |row,idx|
    count+=1 if row[:class].include?('coreContractRow')
    return idx if count==i
  end
  raise "did not find #{i}th core row"
end

Then /^I should see that the (\w+) Fosamax instrument reflects an open (\w+) order for (\d+)$/ do |ordinal,side,amount|
  words = ['first', 'second', 'third', 'fourth']
  idx = words.index(ordinal)
  raise "unsupported ordinal word '#{ordinal}'" if idx.nil?

  # idx is the instrument; idx+1 is the first order under it
  rows = page.all('tr.instrumentRow')
  instrument_row_index = find_core_row_idx(idx, rows)

  x = rows[instrument_row_index+1]

  expect(x[:class]).to include "tradeRow"
  expect(x[:class]).to include "my#{side.capitalize}"
  expect(x).to have_text(amount)
end

Then /^I should see that the first drug period is (\w+)$/ do |status|
  expect(page.first('div.period')).to have_css(".status.#{status}")
end

Then /^the DB should have one drug period that is (\w+)$/ do |status|
  expect(DrugPeriod.where(status: status).count).to eq 1
end

When /^I (\w+) the first drug period$/ do |action|
  click_on "#{action.capitalize} this market"
  find("button", text: "Yes, #{action} this market")
  page.click_button "Yes, #{action} this market"

  anticipate(interval: 0.1, attempts: 10) do
    expect(page).not_to have_css('.swal-modal')
  end
end
