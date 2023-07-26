class AddLabelAndSourceToDrugInstruments < ActiveRecord::Migration[6.0]
  def change
    add_column :drug_instruments, :label, :string
    add_column :drug_instruments, :source, :string
  end
end
