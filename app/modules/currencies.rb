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
      converted_value = value.to_f * cc.to_btc.to_f
      precise_value = ActiveSupport::NumberHelper.number_to_rounded(converted_value, precision: 8).to_f
      trim_trailing_zeros precise_value
    end

    def self.to_doge(value)
      trim_trailing_zeros value.to_f
    end

    def self.to_ltc(value)
      trim_trailing_zeros value.to_f
    end

    # Check for trailing zeros and remove them.
    def self.trim_trailing_zeros(num)
      if num != 0
        if m = num.to_s.match(/([0-9]*)(\.0+[1-9]*|\.0*[1-9]+)(0*)/)
          if m[2].match(/[1-9]+/)
            "#{m[1]}#{m[2]}".to_f
          else
            m[1].to_f
          end
        else
          num
        end
      else
        0
      end
    end

  end
end
