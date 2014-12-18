# Balances

## Contributing
We are excited to open source Balances and get the community involved! Check out [CONTRIBUTING.md](https://github.com/brunchmade/balances/blob/master/CONTRIBUTING.md) for quick guide.

## Setting up Environment
1. Run `bundle install`
1. Copy `.sample.env` to `.env` and update with all the necessary credentials. The required ones are `SECRET_TOKEN` and `EMAIL_HASH_SALT`.
1. Copy `sample.database.yml` to `database.yml`
1. Run `rake db:create db:migrate`
1. Run `rake currency_conversions:populate`
1. Run `foreman start` or `rails s -p 5000`

## Adding a Currency
1. Add to `app/modules/currencies/` a file named after the currency. e.g. `app/modules/currencies/bitcoin.rb`
1. Setup your new currency ruby file with `API`, `CURRENCY_NAME`, `SHORT_NAME`, `SYMBOLS`, `#info`, `#balance`, `#valid?`. e.g. [see below](#currency-file-example)
1. Add currency conversion methods to other currencies and base class. e.g. `#to_btc`
1. Add a currency scope and the currency to the `CURRENCIES` array in `app/models/address.rb`.
1. Update `lib/tasks/currency_conversions.rake#populate`.
1. Run `rake currency_conversions:populate` and `rake currency_conversions:update`
1. Update `app/views/addresses/show.json.rabl` to have corresponding `balance_{{CURRENCY_SHORT_NAME}}` node.
1. Update `gon` in `app/controllers/application_controller.rb#setup_gon`.
1. Update address templates for the sidebar balances, list, list totals, header and the JS view for list totals.
1. Update `@mixin currency-symbols` in `app/assets/stylesheets/mixins_and_variables.scss`.

###### Currency file example:
```ruby
module Currencies
  class Bitcoin < Base

    API = 'https://btc.blockr.io/api/v1'
    CURRENCY_NAME = 'Bitcoin'
    SHORT_NAME = 'BTC'
    SYMBOLS = ['1']

    class << self

      def info(address)
        response = get_response("#{API}/address/info/#{address}")
        response[:data]
      end

      def balance(address)
        response = get_response("#{API}/address/info/#{address}")
        response[:data][:balance]
      end

      def first_tx_at(address)
        response = get_response("#{API}/address/info/#{address}")
        response[:data][:first_tx] ? response[:data][:first_tx][:time_utc] : nil
      end

      def valid?(address)
        response = get_response("#{API}/address/info/#{address}")
        response[:data][:is_valid]
      end

      # Conversions
      def to_btc(value)
        value.to_f
      end

    end
  end
end
```

## Adding a Fiat Currency
1. Update `app/modules/currencies.rb` with corresponding `to_{{CURRENCY_SHORT_NAME}}` method.
1. Update `app/models/currency_conversion.rb` with a `cache_to_{{CURRENCY_NAME}}` method.
1. Update `lib/tasks/currency_conversation.rake#update` and then run it.
1. Update `app/views/addresses/show.json.rabl` with corresponding `balance_{{CURRENCY_SHORT_NAME}}` node.
1. Update `balances` and `totals` nodes in `app/views/users/current_user.json.rabl`.
1. Update `gon.fiat_currencies` in `app/controllers/application_controller.rb#setup_gon`.
