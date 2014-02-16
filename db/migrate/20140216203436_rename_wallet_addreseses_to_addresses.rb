class RenameWalletAddresesesToAddresses < ActiveRecord::Migration
  def self.up
    rename_table :wallet_addresses, :addresses
  end

 def self.down
    rename_table :addresses, :wallet_addresses
 end
end
