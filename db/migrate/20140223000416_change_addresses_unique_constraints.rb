class ChangeAddressesUniqueConstraints < ActiveRecord::Migration
  def up
    remove_index :addresses, :currency
    add_index :addresses, [:public_address, :currency], unique: true
  end

  def down
    remove_index :addresses, [:public_address, :currency]
    add_index :addresses, :currency
  end
end
