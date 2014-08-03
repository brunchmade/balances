class RenameCrypstyIdInCurrencyConversions < ActiveRecord::Migration
  def change
    rename_column :currency_conversions, :crypsty_id, :cryptsy_id
  end
end
