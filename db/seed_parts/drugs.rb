# If these fail, maybe region names changed?
# Check model and update seed.
usa_region = Region.find_by!(name: 'USA')
ww_region = Region.find_by!(name: 'Worldwide')

merck = DrugCompany.find_or_create_by!(name: 'Merck & Co., Inc')
pfizer = DrugCompany.find_or_create_by!(name: 'Pfizer Inc')
acme = DrugCompany.find_or_create_by!(name: 'ACME Worldwide')

# merck drugs
fosamax = Drug.find_or_create_by!(brand_name: 'Fosamax', drug_company: merck)
keytruda = Drug.find_or_create_by!(brand_name: 'Keytruda', drug_company: merck)

# pfizer drugs
celebrex = Drug.find_or_create_by!(brand_name: 'Celebrex', drug_company: pfizer)

# acme
xentrex = Drug.find_or_create_by!(brand_name: 'Xentrex', drug_company: acme)

# -----------------------------


# ========= CLEAN UP!
# 'Monthly' is not a valid DrugPeriod length category.
# Can probably delete this section after every deploy is up to date.
DrugPeriod.where(period_type: ['Monthly', 'Sequential Quarterly', 'Yearly']).destroy_all
# Bugfixes:
DrugPeriod.where(label: 'Q119 - Q119').update(label: 'Q119 - Q219')
# =========

fosa1 = DrugPeriod.find_or_create_by!(drug: fosamax, label: 'Q119 - Q219', period_type: 'Quarterly', region: usa_region)
fosa2 = DrugPeriod.find_or_create_by!(drug: fosamax, label: 'Q219 - Q319', period_type: 'Quarterly', region: usa_region)
DrugPeriod.find_or_create_by!(drug: fosamax, label: 'Q319 - Q419', period_type: 'Quarterly', region: usa_region)
DrugPeriod.find_or_create_by!(drug: fosamax, label: '2019', period_type: 'Annual', region: usa_region)
DrugPeriod.find_or_create_by!(drug: fosamax, label: '2020', period_type: 'Annual', region: usa_region)

DrugPeriod.find_or_create_by!(drug: keytruda, label: 'Q119 - Q219', period_type: 'Quarterly', region: usa_region)
DrugPeriod.find_or_create_by!(drug: keytruda, label: 'Q219 - Q319', period_type: 'Quarterly', region: usa_region)
DrugPeriod.find_or_create_by!(drug: keytruda, label: 'Q319 - Q419', period_type: 'Quarterly', region: usa_region)

DrugPeriod.find_or_create_by!(drug: celebrex, label: '2019', period_type: 'Annual', region: usa_region)
DrugPeriod.find_or_create_by!(drug: celebrex, label: '2020', period_type: 'Annual', region: usa_region)

xentrex1 = DrugPeriod.find_or_create_by!(drug: xentrex, label: 'Q119 - Q219', period_type: 'Quarterly', region: ww_region)

# ======= CLEAN UP PART 2
# Accidentally created a dupe in an earlier seed
tofix = DrugPeriod.where(drug: keytruda, label: 'Q119 - Q219', period_type: 'Quarterly', region: usa_region)
tofix.last.destroy if tofix.count > 1
# ===================

# -----------------------------
DrugInstrument.find_or_create_by!(drug_period: fosa1, net_revenue_projection: 8.5,
  up_leverage_factor: 2, down_leverage_factor: 3,
  up_return_cap: 30, down_return_cap: 40)
DrugInstrument.find_or_create_by!(drug_period: fosa1, net_revenue_projection: 9,
  up_leverage_factor: 2, down_leverage_factor: 3,
  up_return_cap: 30, down_return_cap: 40)
DrugInstrument.find_or_create_by!(drug_period: fosa1, net_revenue_projection: 9.5,
  up_leverage_factor: 3, down_leverage_factor: 4,
  up_return_cap: 25, down_return_cap: 25)

DrugInstrument.find_or_create_by!(drug_period: fosa2, net_revenue_projection: 100,
  up_leverage_factor: 2, down_leverage_factor: 2,
  up_return_cap: 15, down_return_cap: 20)

DrugInstrument.find_or_create_by!(drug_period: xentrex1, net_revenue_projection: 50,
  up_leverage_factor: 5, down_leverage_factor: 5,
  up_return_cap: 7, down_return_cap: 7)

