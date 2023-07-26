source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.readlines('.ruby-version').first.strip

gem 'rails'
gem 'sqlite3'
gem 'puma'
gem 'sass-rails'
gem 'webpacker'
gem 'turbolinks'
gem 'jbuilder'
gem 'bootsnap', require: false
gem 'devise'
gem 'hamlit'
gem 'hamlit-rails'
gem 'factory_bot_rails'
gem 'font-awesome-sass', '~> 5.11.2'
gem 'activeadmin'
gem 'mysql2'
gem 'openssl'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails'
  gem 'rails-controller-testing'
  gem 'pry'
  gem 'anticipate'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console'
  gem 'listen'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'

  gem 'shoulda-matchers'
  gem 'database_cleaner'

  gem 'cucumber-rails', require: false
  gem 'capybara-screenshot'
  gem 'capybara-selenium'
  gem 'ci_reporter_rspec'
end
