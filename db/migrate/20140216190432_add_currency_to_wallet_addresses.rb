class AddCurrencyToWalletAddresses < ActiveRecord::Migration
  def change
    add_column :wallet_addresses, :currency, :text
    add_index :wallet_addresses, :currency
  end
end
