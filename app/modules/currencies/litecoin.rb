module Currencies
  class Litecoin < Base

    API = 'http://explorer.litecoin.net/chain/Litecoin/q'
    CURRENCY_NAME = 'Litecoin'
    SHORT_NAME = 'LTC'
    SYMBOLS = ['L']

    def self.balance(address)
      received_url = "#{API}/getreceivedbyaddress/#{address}"
      received_response = open(received_url) { |v| v.read }
      sent_url = "#{API}/getsentbyaddress/#{address}"
      sent_response = open(sent_url) { |v| v.read }
      received_response.to_f - sent_response.to_f
    end

    def self.valid?(address)
      url = "#{API}/checkaddress/#{address}"
      response = open(url) { |v| v.read }
      !['X5', 'SZ', 'CK'].include?(response)
    end

  end
end
