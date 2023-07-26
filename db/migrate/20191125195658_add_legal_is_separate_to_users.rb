class AddLegalIsSeparateToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :legal_is_separate, :boolean, default: false
  end
end
