class AddBalanceBtcToAddresses < ActiveRecord::Migration
  def up
    add_column :addresses, :balance_btc, :decimal, precision: 18, scale: 8, default: 0

    Address.find_each do |address|
      currency = address.get_currency
      address.update_attributes(balance_btc: currency.to_btc(address.balance))
    end
  end

  def down
    remove_column :addresses, :balance_btc
  end
end
