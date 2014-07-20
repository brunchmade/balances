class AddEmailColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_subscribed, :boolean, default: true
    add_column :users, :email_hash, :text

    add_index :users, :is_subscribed
    add_index :users, :email_hash
  end
end
