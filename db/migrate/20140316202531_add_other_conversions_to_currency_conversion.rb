class AddOtherConversionsToCurrencyConversion < ActiveRecord::Migration
  def change
    add_column :currency_conversions, :to_eur, :decimal, precision: 18, scale: 8
    add_column :currency_conversions, :to_jpy, :decimal, precision: 18, scale: 8
    add_column :currency_conversions, :to_gbp, :decimal, precision: 18, scale: 8
  end
end
