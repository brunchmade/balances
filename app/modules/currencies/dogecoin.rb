module Currencies
  class Dogecoin < Base

    CURRENCY_NAME = 'Dogecoin'
    SHORT_NAME = 'DOGE'
    SYMBOLS = ['D']

    def self.balance(address)
      url = "http://dogechain.info/chain/Dogecoin/q/addressbalance/#{address}"
      response = open(url) { |v| v.read }
      response.to_f
    end

  end
end
