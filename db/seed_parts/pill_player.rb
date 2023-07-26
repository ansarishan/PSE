pill_player = Organization.find_or_create_by!(name: 'PillPlayer LLC')


# -- PillPlayer Users

User.find_or_create_by!(username: 'ppadmin') do |u|
  u.organization = pill_player
  u.role = 'org_admin'
  u.email = 'admin@pillplayer.example.com'
  u.password = u.password_confirmation = 'Password123!'
  u.has_signed_eula = true
  u.onboarded = true
  u.first_name = 'Bruce'
  u.last_name = 'Wayne'
  u.phone = '555 555-5555'
  u.address = FactoryBot.build(:address, line1: '123 PillPlayer Street')
end

User.find_or_create_by!(username: 'pptrader') do |u|
  u.organization = pill_player
  u.role = 'trader'
  u.email = 'trader@pillplayer.example.com'
  u.password = u.password_confirmation = 'Password123!'
  u.has_signed_eula = true
  u.onboarded = false
  u.first_name = 'Tim'
  u.last_name = 'Drake'
  u.phone = '555 555-5555'
  u.address = FactoryBot.build(:address, line1: '123 Trader Blvd')
end

User.find_or_create_by!(username: 'ppanalyst') do |u|
  u.organization = pill_player
  u.role = 'analyst'
  u.email = 'analyst@pillplayer.example.com'
  u.password = u.password_confirmation = 'Password123!'
  u.has_signed_eula = true
  u.onboarded = false
  u.first_name = 'Jason'
  u.last_name = 'Todd'
  u.phone = '555 555-5555'
  u.address = FactoryBot.build(:address, line1: '123 Analyst Lane')
end

User.find_or_create_by!(username: 'pplegal') do |u|
  u.organization = pill_player
  u.role = 'legal'
  u.email = 'legal@pillplayer.example.com'
  u.password = u.password_confirmation = 'Password123!'
  u.has_signed_eula = true
  u.onboarded = false
  u.first_name = 'Dick'
  u.last_name = 'Grayson'
  u.phone = '555 555-5555'
  u.legal_is_separate = true
  u.address = FactoryBot.build(:address, line1: '123 Legal Drive')
end

