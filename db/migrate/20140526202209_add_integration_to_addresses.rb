class AddIntegrationToAddresses < ActiveRecord::Migration
  def up
    remove_index :addresses, [:public_address, :currency]
    add_index :addresses, [:public_address, :currency]
    add_column :addresses, :integration, :text
  end

  def down
    remove_column :addresses, :integration, :text
    remove_index :addresses, [:public_address, :currency]
    add_index :addresses, [:public_address, :currency], unique: true
  end
end
