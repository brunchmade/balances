module Currencies
  class Litecoin < Base

    API = 'https://ltc.blockr.io/api/v1'
    CURRENCY_NAME = 'Litecoin'
    SHORT_NAME = 'LTC'
    SYMBOLS = ['L']

    class << self

      def info(address)
        response = get_response("#{API}/address/info/#{address}")
        info = response[:data]
        info[:first_tx_at] = info[:first_tx] ? info[:first_tx][:time_utc] : nil
        info
      end

      def balance(address)
        response = get_response("#{API}/address/info/#{address}")
        response[:data][:balance]
      end

      def valid?(address)
        response = get_response("#{API}/address/info/#{address}")
        response[:data][:is_valid]
      end

      # Conversions
      def to_btc(value)
        cc = CurrencyConversion.find_by_name(currency_name)
        value.to_f * cc.to_btc.to_f
      end

      def to_doge(value)
        value_btc = to_btc(value)
        Currencies::Bitcoin.to_doge value_btc
      end

      def to_vtc(value)
        value_btc = to_btc(value)
        Currencies::Bitcoin.to_vtc value_btc
      end

    end
  end
end
