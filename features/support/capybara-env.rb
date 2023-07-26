require 'selenium/webdriver'
require 'capybara-screenshot/cucumber'
require 'csv'
require 'anticipate'

# Cuke page requests are sent to:
#Capybara.app_host = "http://127.0.0.1:3000"

# Puma
#Capybara.server_port = 3001 #port that Puma is listening on

# remove "_headless" if you want to see the browser pop up
Capybara.default_driver = :selenium_chrome_headless
Capybara.javascript_driver = :selenium_chrome_headless

# default is 2
#Capybara.default_max_wait_time = 30

include Anticipate
