class DrugPeriod < ApplicationRecord
  belongs_to :region
  belongs_to :drug, inverse_of: :drug_periods
  has_many :drug_instruments, inverse_of: :drug_period, dependent: :destroy
  has_one :drug_company, through: :drug
  enum status: {
    closed: 0,
    open: 1,
    expired: 2
  }

 
  VALID_TYPES = ['Quarterly', 'Semi-annual', 'Annual']
  
  validates :label, presence: true,
                    uniqueness: { scope: :drug_id, message: 'has already been taken for this drug' }
  validates :drug, presence: true
  validates :period_type, presence: true,
                          inclusion: { in: VALID_TYPES }
  validate :status_transition

  
  def status_transition
    if !self.net_revenue_actual.nil? && (self.expired? == false)
      errors.add(:drug_period, "Status must be expired when Net Revenue Actual is not blank")
    end
    if self.net_revenue_actual.nil? && (self.expired?)
      errors.add(:drug_period, "Net Revenue Actual cannot be blank when Status is #{self.status}")
    end
  end

  def display_name
    "#{region.name}/#{drug.drug_company.name}/#{drug.brand_name}/#{period_type}/#{label}"
  end

  def menu_trail
    { region: region,
      company: drug.drug_company,
      drug: drug,
      period: self
    }
  end

end
