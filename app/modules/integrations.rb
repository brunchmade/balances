module Integrations
  class Base
    class << self

      # Constants getters
      def integration_name
        defined?(self::INTEGRATION_NAME) ? self::INTEGRATION_NAME : 'Integration name undefined.'
      end

      def currency_name
        defined?(self::CURRENCY_NAME) ? self::CURRENCY_NAME : 'Currency name undefined.'
      end

    end
  end
end
