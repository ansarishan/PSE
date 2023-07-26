User.create!(
  username: 'admin',
  role: 'admin',
  email: 'admin@example.com',
  password: 'Password123!',
  password_confirmation: 'Password123!') unless User.find_by(username: 'admin')
