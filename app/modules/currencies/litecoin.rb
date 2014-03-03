module Currencies
  class Litecoin < Base

    CURRENCY_NAME = 'Litecoin'
    SHORT_NAME = 'LTC'
    SYMBOLS = ['L']

    def self.balance(address)
      received_url = "http://explorer.litecoin.net/chain/Litecoin/q/getreceivedbyaddress/#{address}"
      received_response = open(received_url) { |v| v.read }
      sent_url = "http://explorer.litecoin.net/chain/Litecoin/q/getsentbyaddress/#{address}"
      sent_response = open(sent_url) { |v| v.read }
      received_response.to_f - sent_response.to_f
    end

  end
end
