class TwoFactorAuthenticationAddToUsers < ActiveRecord::Migration
  def up
    change_table :users do |t|
      t.string   :otp_secret_key
      t.integer  :second_factor_attempts_count, :default => 0
      t.boolean  :has_two_factor_enabled, :default => false
    end

    add_index :users, :otp_secret_key, :unique => true
  end

  def down
    remove_column :users, :otp_secret_key
    remove_column :users, :second_factor_attempts_count
    remove_column :users, :has_two_factor_enabled
  end
end
