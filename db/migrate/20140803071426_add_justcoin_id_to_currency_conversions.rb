class AddJustcoinIdToCurrencyConversions < ActiveRecord::Migration
  def change
    add_column :currency_conversions, :justcoin_id, :text
  end
end
