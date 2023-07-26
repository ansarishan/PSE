chem_bettor = Organization.find_or_create_by!(name: 'ChemBettor Partners')


# -- ChemBettor Users

User.find_or_create_by!(username: 'cbadmin') do |u|
  u.organization = chem_bettor
  u.role = 'org_admin'
  u.email = 'admin@chembettor.example.com'
  u.password = u.password_confirmation = 'Password123!'
  u.has_signed_eula = true
  u.onboarded = true
  u.first_name = 'Charles'
  u.last_name = 'Xavier'
  u.phone = '555 555-5555'
  u.address = FactoryBot.build(:address, line1: '123 ChemBettor Street')
end

User.find_or_create_by!(username: 'cbtrader') do |u|
  u.organization = chem_bettor
  u.role = 'trader'
  u.email = 'trader@chembettor.example.com'
  u.password = u.password_confirmation = 'Password123!'
  u.has_signed_eula = true
  u.onboarded = false
  u.first_name = 'Scott'
  u.last_name = 'Summers'
  u.phone = '555 555-5555'
  u.address = FactoryBot.build(:address, line1: '123 Trader Blvd')
end

User.find_or_create_by!(username: 'cbanalyst') do |u|
  u.organization = chem_bettor
  u.role = 'analyst'
  u.email = 'analyst@chembettor.example.com'
  u.password = u.password_confirmation = 'Password123!'
  u.has_signed_eula = true
  u.onboarded = false
  u.first_name = 'Bobby'
  u.last_name = 'Drake'
  u.phone = '555 555-5555'
  u.address = FactoryBot.build(:address, line1: '123 Analyst Lane')
end

User.find_or_create_by!(username: 'cblegal') do |u|
  u.organization = chem_bettor
  u.role = 'legal'
  u.email = 'legal@chembettor.example.com'
  u.password = u.password_confirmation = 'Password123!'
  u.has_signed_eula = true
  u.onboarded = false
  u.first_name = 'Ororo'
  u.last_name = 'Munroe'
  u.phone = '555 555-5555'
  u.legal_is_separate = true
  u.address = FactoryBot.build(:address, line1: '888 ChemBet Blvd')
end

