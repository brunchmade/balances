module Currencies
  class Dogecoin < Base

    API = 'http://dogechain.info/chain/Dogecoin/q'
    CURRENCY_NAME = 'Dogecoin'
    SHORT_NAME = 'DOGE'
    SYMBOLS = ['D']

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

  end
end
