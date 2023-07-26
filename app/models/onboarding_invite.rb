class OnboardingInvite < ApplicationRecord
  belongs_to :user, optional: true, inverse_of: :onboarding_invite

  validates :url_code, presence: true
  validates :email, presence: true
  validates_format_of :email, :with => Devise::email_regexp, allow_blank: true

  def self.generate_url_code
    100.times do
      x = SecureRandom.hex
      return x unless OnboardingInvite.find_by(url_code: x)
    end
    raise 'Could not generate unique url_code'
  end

  def invite_url
    Rails.application.routes.url_helpers.org_onboarding_init_path(url_code)
  end
end
