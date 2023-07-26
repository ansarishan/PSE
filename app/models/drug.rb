class Drug < ApplicationRecord
  belongs_to :drug_company, inverse_of: :drugs
  has_many :drug_periods, inverse_of: :drug, dependent: :destroy

  validates :drug_company, presence: true
  validates :brand_name, presence: true,
                         uniqueness: { scope: :drug_company_id, message: 'has already been taken for this company' }

  def display_name
    brand_name
  end

  def to_h_for_sidemenu
    period_types = {}
    drug_periods.each do |dp|
      period_types[dp.period_type] ||= []
      period_types[dp.period_type] << { id: dp.id, label: dp.label, status: dp.status }
    end
    { id: id, brand_name: brand_name, period_types: period_types }
  end
end
