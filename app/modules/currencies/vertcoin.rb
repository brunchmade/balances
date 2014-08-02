module Currencies
  class Vertcoin < Base

    API = 'https://explorer.vertcoin.org/chain/vertcoin/q'
    CURRENCY_NAME = 'Vertcoin'
    SHORT_NAME = 'VTC'
    SYMBOLS = ['V']

    class << self

      def info(address)
        info = {}.with_indifferent_access
        info[:balance] = balance(address)
        info[:is_valid] = valid?(address)
        info[:first_tx_at] = nil
        info
      end

      def balance(address)
        response = get_response("#{API}/addressbalance/#{address}", {
          force_sslv3: true,
          parse_json: false
        })
        response.to_f
      end

      def valid?(address)
        response = get_response("#{API}/checkaddress/#{address}", {
          force_sslv3: true,
          parse_json: false
        })
        !['X5', 'SZ', 'CK'].include?(response)
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

      def to_ltc(value)
        value_btc = to_btc(value)
        Currencies::Bitcoin.to_ltc value_btc
      end

    end
  end
end
