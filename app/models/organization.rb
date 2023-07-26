class Organization < ApplicationRecord
  has_many :users, inverse_of: :organization, dependent: :destroy
  has_many :orders, inverse_of: :organization, dependent: :nullify
  has_many :quotes, inverse_of: :organization, dependent: :nullify
  has_many :tradables, inverse_of: :organization, dependent: :nullify

  validate :no_more_than_one_of_each_user_type

  def received_quotes
    Quote.where(counter_order_id: orders.pluck(:id))
  end

  private

  def no_more_than_one_of_each_user_type
    # Can't use `users.where`, because we need to test the in-memory state, not in-db state.
    errors.add(:users, 'can not have more than 1 Organizational Admin user') if users.count{|u| u.role=='org_admin'} > 1
    errors.add(:users, 'can not have more than 1 Legal user') if users.count{|u| u.role=='legal'} > 1
    errors.add(:users, 'can not have more than 1 Trader user') if users.count{|u| u.role=='trader'} > 1
    errors.add(:users, 'can not have more than 1 Analyst user') if users.count{|u| u.role=='analyst'} > 1
  end

end
