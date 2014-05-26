module Integrations
  class Base

    # Constants getters
    def self.integration_name
      defined?(self::INTEGRATION_NAME) ? self::INTEGRATION_NAME : 'Integration name undefined.'
    end

    def self.currency_name
      defined?(self::CURRENCY_NAME) ? self::CURRENCY_NAME : 'Currency name undefined.'
    end

  end
end
