module Currencies
  class Bitcoin < Base

    API = 'http://blockchain.info'
    CURRENCY_NAME = 'Bitcoin'
    SHORT_NAME = 'BTC'
    SYMBOLS = ['1']

    def self.balance(address)
      url = "#{API}/address/#{address}?format=json"
      response = open(url) { |v| JSON(v.read).with_indifferent_access }
      # Converting because response is in Satoshi
      response[:final_balance] / 100000000.to_f
    end

    def self.valid?(address)
      url = URI.parse("#{API}/address/#{address}?format=json")
      req = Net::HTTP.new(url.host, url.port)
      res = req.request_head(url.path)
      res.code == '200'
    end

  end
end
