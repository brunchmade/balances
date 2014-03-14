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

    # Conversions
    def self.to_btc(value)
      trim_trailing_zeros value
    end

    def self.to_doge(value)
      cc = CurrencyConversion.find_by_name(Currencies::Dogecoin.currency_name)
      converted_value = value.to_f / cc.to_btc.to_f
      precise_value = ActiveSupport::NumberHelper.number_to_rounded(converted_value, precision: 8).to_f
      trim_trailing_zeros precise_value
    end

    def self.to_ltc(value)
      cc = CurrencyConversion.find_by_name(Currencies::Litecoin.currency_name)
      converted_value = value.to_f / cc.to_btc.to_f
      precise_value = ActiveSupport::NumberHelper.number_to_rounded(converted_value, precision: 8).to_f
      trim_trailing_zeros precise_value
    end

  end
end
