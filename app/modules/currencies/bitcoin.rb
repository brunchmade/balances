module Currencies
  class Bitcoin < Base

    API = 'https://btc.blockr.io/api/v1'
    CURRENCY_NAME = 'Bitcoin'
    SHORT_NAME = 'BTC'
    SYMBOLS = ['1']

    def self.info(address)
      response = self.get_response("#{API}/address/info/#{address}")
      info = response[:data]
      info[:first_tx_at] = info[:first_tx][:time_utc]
      info
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

    def self.to_doge(value)
      cc = CurrencyConversion.find_by_name(Currencies::Dogecoin.currency_name)
      value.to_f / cc.to_btc.to_f
    end

    def self.to_ltc(value)
      cc = CurrencyConversion.find_by_name(Currencies::Litecoin.currency_name)
      value.to_f / cc.to_btc.to_f
    end

  end
end
