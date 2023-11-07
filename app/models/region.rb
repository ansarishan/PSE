class Region < ApplicationRecord
  has_many :drug_periods

  VALID_NAMES = ['Worldwide', 'USA', 'International', 'Developed Non-US', 'Emerging Markets']

  validates :name, presence: true,
                   uniqueness: true,
                   inclusion: { in: VALID_NAMES }

  def self.default
    Region.find_by(name: 'Worldwide') || Region.first
  end

  def to_h_for_sidemenu
    { id: id, name: name, companies: drug_companies.collect {|dc| dc.to_h_for_sidemenu} }
  end

  def self.data_for_side_menu
    # TODO maybe-- This chain of to_h_for_sidemenu calls is query-intensive.
    #              I'm sure it can be optimized.
    Region.order(:name).collect(&:to_h_for_sidemenu)
  end

  def drug_companies
    DrugCompany.where(id: DrugPeriod.includes(:drug_company).where(region_id: self.id).pluck(:drug_company_id).uniq)
  end

  def self.is_drug_companies_ss(organization_id)
    organization_id_string = "%#{organization_id}%"
    result = Drug.where("special_situation LIKE ?", organization_id_string)
    result.count > 0
  end
end
