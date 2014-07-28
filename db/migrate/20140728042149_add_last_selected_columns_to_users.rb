class AddLastSelectedColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_selected_fiat, :text
    add_column :users, :last_selected_conversion, :text
  end
end
