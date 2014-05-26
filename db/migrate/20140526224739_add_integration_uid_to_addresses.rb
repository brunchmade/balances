class AddIntegrationUidToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :integration_uid, :text
    add_index :addresses, [:integration_uid, :integration]
  end
end
