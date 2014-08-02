module Currencies
  class Bitcoin < Base

    API = 'https://btc.blockr.io/api/v1'
    CURRENCY_NAME = 'Bitcoin'
    SHORT_NAME = 'BTC'
    SYMBOLS = ['1']

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
      def to_doge(value)
        cc = CurrencyConversion.find_by_name(Currencies::Dogecoin.currency_name)
        value.to_f / cc.to_btc.to_f
      end

      def to_ltc(value)
        cc = CurrencyConversion.find_by_name(Currencies::Litecoin.currency_name)
        value.to_f / cc.to_btc.to_f
      end

      def to_vtc(value)
        cc = CurrencyConversion.find_by_name(Currencies::Vertcoin.currency_name)
        value.to_f / cc.to_btc.to_f
      end

    end
  end
end
