require 'open-uri'

module Currencies
  class Base

    def self.currency_name
      defined?(self::CURRENCY_NAME) ? self::CURRENCY_NAME : 'Currency name undefined.'
    end

    def self.short_name
      defined?(self::SHORT_NAME) ? self::SHORT_NAME : 'Short name undefined.'
    end

    def self.symbols
      defined?(self::SYMBOLS) ? self::SYMBOLS : 'Symbol undefined.'
    end

    def self.info(address = nil)
      raise NotImplementedError.new("You must implment #{name}#info")
    end

    def self.balance(address = nil)
      raise NotImplementedError.new("You must implment #{name}#balances")
    end

    def self.valid?(address = nil)
      raise NotImplementedError.new("You must implment #{name}#valid?")
    end

  end
end
