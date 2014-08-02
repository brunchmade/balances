module Currencies
  class Vertcoin < Base

    API = 'https://explorer.vertcoin.org/chain/vertcoin/q'
    CURRENCY_NAME = 'Vertcoin'
    SHORT_NAME = 'VTC'
    SYMBOLS = ['V']

    def self.info(address)
      info = {}.with_indifferent_access
      info[:balance] = balance(address)
      info[:is_valid] = valid?(address)
      info[:first_tx_at] = nil
      info
    end

    def self.balance(address)
      response = self.get_response("#{API}/addressbalance/#{address}", {
        force_sslv3: true,
        parse_json: false
      })
      response.to_f
    end

    def self.valid?(address)
      response = self.get_response("#{API}/checkaddress/#{address}", {
        force_sslv3: true,
        parse_json: false
      })
      !['X5', 'SZ', 'CK'].include?(response)
    end

    # Conversions
    def self.to_btc(value)
      cc = CurrencyConversion.find_by_name(self.currency_name)
      value.to_f * cc.to_btc.to_f
    end

    def self.to_doge(value)
      value_btc = self.to_btc(value)
      Currencies::Bitcoin.to_doge value_btc
    end

    def self.to_ltc(value)
      value_btc = self.to_btc(value)
      Currencies::Bitcoin.to_ltc value_btc
    end

  end
end
