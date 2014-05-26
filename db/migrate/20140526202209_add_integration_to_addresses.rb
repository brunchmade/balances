class AddIntegrationToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :integration, :boolean, default: false
    add_index :addresses, :integration
  end
end
