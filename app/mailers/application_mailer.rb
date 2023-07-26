class ApplicationMailer < ActionMailer::Base
  default from: Rails.configuration.x.default_mailer_from.presence || 'admin@example.com'
  layout 'mailer'

  def self.naive_url(relpath)
    protocol = ActionMailer::Base.default_url_options[:protocol] || 'http'
    host = ActionMailer::Base.default_url_options[:host]
    port = ActionMailer::Base.default_url_options[:port]

    str = "#{protocol}://#{host}"
    str << ":#{port}" if port.present?
    str << '/' unless relpath.start_with?('/')
    str << relpath
  end
end
