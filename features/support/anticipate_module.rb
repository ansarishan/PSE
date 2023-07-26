require 'anticipate'

# named -Module to avoid any possible name conflict

module AnticipateModule
  include Anticipate

  def anticipate(interval: 0.1, attempts: 10)
    yield
  end
end

include AnticipateModule
