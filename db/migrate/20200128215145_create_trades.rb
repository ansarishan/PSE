class CreateTrades < ActiveRecord::Migration[6.0]
  def change
    create_table :trades do |t|
      t.integer :state, default: 0, null: false
      t.timestamps
    end

    add_reference :orders, :trade, foreign_key: true
  end
end
