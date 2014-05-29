class AddColumnsToTokens < ActiveRecord::Migration
  def up
    remove_index :tokens, :token

    add_column :tokens, :refresh_token, :text
    add_column :tokens, :expires_at, :timestamp
    add_column :tokens, :provider, :text
    add_column :tokens, :provider_uid, :text

    add_index :tokens, [:token, :provider], unique: true
    add_index :tokens, [:provider_uid, :provider], unique: true
  end

  def down
    remove_index :tokens, [:token, :provider]
    remove_index :tokens, [:provider_uid, :provider]

    remove_column :tokens, :refresh_token
    remove_column :tokens, :expires_at
    remove_column :tokens, :provider
    remove_column :tokens, :provider_uid

    add_index :tokens, :token, unique: true
  end
end
