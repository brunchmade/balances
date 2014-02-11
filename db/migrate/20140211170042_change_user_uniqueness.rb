class ChangeUserUniqueness < ActiveRecord::Migration
  def up
    change_column :users, :email, :string, null: true
    change_column_default :users, :email, nil
    remove_index :users, :email
    add_index :users, :email
    remove_index :users, :username
    add_index :users, :username
  end

  def down
    change_column :users, :email, :string, default: '', null: false
    remove_index :users, :email
    add_index :users, :email, unique: true
    remove_index :users, :username
    add_index :users, :username, unique: true
  end
end
