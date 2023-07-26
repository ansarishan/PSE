class Address < ApplicationRecord
  belongs_to :user, inverse_of: :address

  validates :user, presence: true
  validates :city, presence: true
  validates :country, presence: true
end
