class AddUpsideGainToTrade < ActiveRecord::Migration[6.0]
  def change
    add_column :trades, :upside_gain, :decimal
  end
end
