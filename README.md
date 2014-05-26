# Balances

## Adding a Currency
1. Add to `app/modules/currencies/` a file named after the currency. e.g. `app/modules/currencies/bitcoin.rb`
2. Setup your new currency ruby file with `API`, `CURRENCY_NAME`, `SHORT_NAME`, `SYMBOLS`, `#info`, `#balance`, `#valid?`. e.g. [see below](#currency-file-example)
3. Add the currency to the `CURRENCIES` array in `app/models/address.rb`.
4. Add currency conversion methods to other currencies and base class. e.g. `#to_btc`
5. Update 'lib/tasks/currency_conversation.rake#populate'.

###### Currency file example:
```ruby
module Currencies
  class Bitcoin < Base

    API = 'https://btc.blockr.io/api/v1'
    CURRENCY_NAME = 'Bitcoin'
    SHORT_NAME = 'BTC'
    SYMBOLS = ['1']

    def self.info(address)
      response = self.get_response("#{API}/address/info/#{address}")
      response[:data]
    end

    def self.balance(address)
      response = self.get_response("#{API}/address/info/#{address}")
      response[:data][:balance]
    end

    def self.valid?(address)
      response = self.get_response("#{API}/address/info/#{address}")
      response[:data][:is_valid]
    end

    # Conversions
    def self.to_btc(value)
      value.to_f
    end

  end
end
```
