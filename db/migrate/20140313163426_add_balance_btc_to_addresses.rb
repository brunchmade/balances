class AddBalanceBtcToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :balance_btc, :decimal, precision: 18, scale: 8, default: 0
  end
end
