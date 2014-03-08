module Currencies
  class Bitcoin < Base

    API = 'https://btc.blockr.io/api/v1'
    CURRENCY_NAME = 'Bitcoin'
    SHORT_NAME = 'BTC'
    SYMBOLS = ['1']

    def self.info(address)
      url = "#{API}/address/info/#{address}"
      response = open(url) { |v| JSON(v.read).with_indifferent_access }
      response[:data]
    end

    def self.balance(address)
      url = "#{API}/address/info/#{address}"
      response = open(url) { |v| JSON(v.read).with_indifferent_access }
      response[:data][:balance]
    end

    def self.valid?(address)
      url = "#{API}/address/info/#{address}"
      response = open(url) { |v| JSON(v.read).with_indifferent_access }
      response[:data][:is_valid]
    end

  end
end
