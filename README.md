# Balances

## Adding a Currency
1. Add to `app/modules/currencies` and file named after the currency. e.g. `app/modules/currencies/bitcoin.rb`
2. Setup your new currency ruby file with `CURRENCY_NAME`, `SHORT_NAME`, `SYMBOLS` and `#balance`. e.g. [see below](#currency-file-example)
3. Add the currency to the `CURRENCIES` array in `app/models/address.rb`.

###### Currency file example:
```ruby
module Currencies
  class Bitcoin < Base

    CURRENCY_NAME = 'Bitcoin'
    SHORT_NAME = 'BTC'
    SYMBOLS = ['1']

    def self.balance(address)
      url = "http://blockchain.info/address/#{address}?format=json"
      response = open(url) { |v| JSON(v.read).with_indifferent_access }
      # Converting because response is in Satoshi
      response[:final_balance] / 100000000.to_f
    end

  end
end
```
