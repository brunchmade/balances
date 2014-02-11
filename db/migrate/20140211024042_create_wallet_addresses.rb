class CreateWalletAddresses < ActiveRecord::Migration
  def change
    create_table :wallet_addresses do |t|
      t.text :public_address
      t.text :name
      t.integer :user_id

      t.timestamps
    end

    add_index :wallet_addresses, :user_id
  end
end
