class AddTypeToOrders < ActiveRecord::Migration[6.0]
  def change
    rename_table :orders, :tradables
    add_column :tradables, :type, :string, default: 'Order'
    add_column :tradables, :counter_order_id, :integer
  end
end
