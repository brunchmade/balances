class AddFirstTxAtToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :first_tx_at, :timestamp
  end
end
