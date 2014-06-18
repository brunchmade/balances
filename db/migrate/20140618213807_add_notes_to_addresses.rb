class AddNotesToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :notes, :text
  end
end
