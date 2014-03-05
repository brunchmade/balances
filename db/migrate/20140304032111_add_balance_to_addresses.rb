class AddBalanceToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :balance, :decimal, precision: 18, scale: 8, default: 0
  end
end
