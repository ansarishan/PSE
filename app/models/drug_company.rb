class DrugCompany < ApplicationRecord
  has_many :drugs, inverse_of: :drug_company, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  def to_h_for_sidemenu
    { id: id, name: name, drugs: drugs.collect {|d| d.to_h_for_sidemenu} }
  end
end
