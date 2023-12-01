class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, and :omniauthable
  devise :database_authenticatable,
         :rememberable,
         :trackable
         # :registerable - to let users sign up themselves ("sign up" link at login form)
         # :recoverable - "forgot your password?" at sign up form
         #                WARNING: Since we're using username, some other work will be needed.
         #                         See https://github.com/plataformatec/devise/wiki/How-To:-Allow-users-to-sign-in-with-something-other-than-their-email-address
         # :validatable - not using this one because we allow blank passwords (for unconfirmed users)

  enum role: {
    admin: 0,
    org_admin: 1,
    legal: 2,
    trader: 3,
    analyst: 4
  }

# TODO make a 'name' function or something for AA to use: {username||email}

  has_one :onboarding_invite, inverse_of: :user, dependent: :nullify
  has_one :address, inverse_of: :user, dependent: :destroy
  belongs_to :organization, inverse_of: :users, optional: true

  accepts_nested_attributes_for :organization, :address

  validates :username, uniqueness: true, allow_blank: true
  validates :email, presence: true
  validates_format_of :email, :with => Devise::email_regexp, allow_blank: true
  validates :has_signed_eula, inclusion: { in: [true, false] }
  validates :onboarded, inclusion: { in: [true, false] }
  validates :role, presence: true
  validates :organization, presence: true, unless: -> { admin? }
  validates :legal_is_separate, inclusion: { in: [true, false] }
  validates :password, length: { minimum: 6 }, allow_blank: true

  validate :org_doesnt_have_this_role_already
  validate :passwords_match

  def name_for_display
    "#{first_name} #{last_name}".strip.presence || username
  end

  def pretty_role
    case role
    when 'admin'; 'Site Admin'
    when 'org_admin'; 'Org Admin'
    else role.capitalize
    end
  end

  private

  def passwords_match
    return if password.blank?
    return if password==password_confirmation
    errors.add(:password_confirmation, "doesn't match Password")
  end

  def org_doesnt_have_this_role_already
    #return if (role.nil? || organization.nil?)
    #if (organization.users.to_a - [self]).any?{|u| u.role==self.role}
      #errors.add(:organization, 'already has a user of this type')
    #end
  end
end
