module Currencies
  class Bitcoin < Base

    CURRENCY_NAME = 'Bitcoin'
    SHORT_NAME = 'BTC'
    SYMBOLS = ['1']

    def self.balance(address)
      url = "http://blockchain.info/address/#{address}?format=json"
      response = open(url) { |v| JSON(v.read).with_indifferent_access }
      # Converting because response is in Satoshi
      response[:final_balance] / 100000000.to_f
    end

  end
end
