class CreateCurrencyConversions < ActiveRecord::Migration
  def change
    create_table :currency_conversions do |t|
      t.text :name
      t.integer :crypsty_id
      t.decimal :to_btc, precision: 18, scale: 8
      t.decimal :to_usd, precision: 18, scale: 8

      t.timestamps
    end

    add_index :currency_conversions, :name, unique: true
  end
end
