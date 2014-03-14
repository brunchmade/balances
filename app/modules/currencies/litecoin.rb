module Currencies
  class Litecoin < Base

    API = 'https://ltc.blockr.io/api/v1'
    CURRENCY_NAME = 'Litecoin'
    SHORT_NAME = 'LTC'
    SYMBOLS = ['L']

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

    # Conversions
    def self.to_doge(value)
      value_btc = self.to_btc(value)
      Currencies::Bitcoin.to_doge value_btc
    end

  end
end
