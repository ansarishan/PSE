require 'devise'

module ControllerMacros
  def login(user)
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in(user)

    if block_given?
      yield
      sign_out(user)
    end
  end
end

RSpec.configure do |config|
  config.include Devise::Test::ControllerHelpers, :type => :controller
  config.extend ControllerMacros, :type => :controller
  config.include ControllerMacros, :type => :controller
end
