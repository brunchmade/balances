module Currencies
  class Dogecoin < Base

    API = 'https://dogechain.info/chain/Dogecoin/q'
    CURRENCY_NAME = 'Dogecoin'
    SHORT_NAME = 'DOGE'
    SYMBOLS = ['D']

    def self.info(address)
      info = {}.with_indifferent_access
      info[:balance] = balance(address)
      info[:is_valid] = valid?(address)
      info
    end

    def self.balance(address)
      url = "#{API}/addressbalance/#{address}"
      response = open(url) { |v| v.read }
      response.to_f
    end

    def self.valid?(address)
      url = "#{API}/checkaddress/#{address}"
      response = open(url) { |v| v.read }
      !['X5', 'SZ', 'CK'].include?(response)
    end

    # Conversions
    def self.to_ltc(value)
      value_btc = self.to_btc(value)
      Currencies::Bitcoin.to_ltc value_btc
    end

  end
end
