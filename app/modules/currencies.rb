require 'open-uri'

module Currencies
  class Base

    # Constants getters
    def self.currency_name
      defined?(self::CURRENCY_NAME) ? self::CURRENCY_NAME : 'Currency name undefined.'
    end

    def self.short_name
      defined?(self::SHORT_NAME) ? self::SHORT_NAME : 'Short name undefined.'
    end

    def self.symbols
      defined?(self::SYMBOLS) ? self::SYMBOLS : 'Symbol undefined.'
    end

    # Implemented methods
    def self.info(address = nil)
      raise NotImplementedError.new("You must implment #{name}#info")
    end

    def self.balance(address = nil)
      raise NotImplementedError.new("You must implment #{name}#balances")
    end

    def self.valid?(address = nil)
      raise NotImplementedError.new("You must implment #{name}#valid?")
    end

    # Conversions
    # Currencies other than BTC only need to implement conversion methods
    # for currencies that are not BTC or themselves.
    def self.to_btc(value)
      cc = CurrencyConversion.find_by_name(self.currency_name)
      value.to_f * cc.to_btc.to_f
    end

    def self.to_doge(value)
      value.to_f
    end

    def self.to_ltc(value)
      value.to_f
    end

    def self.to_usd(value)
      cc = CurrencyConversion.find_by_name(self.currency_name)
      value.to_f * cc.to_usd.to_f
    end

    def self.to_eur(value)
      cc = CurrencyConversion.find_by_name(self.currency_name)
      value.to_f * cc.to_eur.to_f
    end

    def self.to_gbp(value)
      cc = CurrencyConversion.find_by_name(self.currency_name)
      value.to_f * cc.to_gbp.to_f
    end

    def self.to_jpy(value)
      cc = CurrencyConversion.find_by_name(self.currency_name)
      value.to_f * cc.to_jpy.to_f
    end

  end
end
