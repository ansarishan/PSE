class AddCompoundAndGenericNameToDrugs < ActiveRecord::Migration[6.0]
  def change
    add_column :drugs, :compound_name, :string
    add_column :drugs, :generic_name, :string
  end
end
