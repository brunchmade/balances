module Currencies
  class Base
    class << self

      # Constants getters
      def currency_name
        defined?(self::CURRENCY_NAME) ? self::CURRENCY_NAME : 'Currency name undefined.'
      end

      def short_name
        defined?(self::SHORT_NAME) ? self::SHORT_NAME : 'Short name undefined.'
      end

      def symbols
        defined?(self::SYMBOLS) ? self::SYMBOLS : 'Symbol undefined.'
      end

      # General methods
      def get_response(url, opts = {})
        options = {
          force_sslv3: false,
          force_tlsv1_2: false,
          parse_json: true
        }.merge(opts)

        uri = URI.parse(url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true

        if false #options[:force_sslv3]
          http.ssl_version = :SSLv3
        elsif false #options[:force_tlsv1_2]
          http.ssl_version = :TLSv1_2
        else
          http.verify_mode = OpenSSL::SSL::VERIFY_PEER
          # http.ssl_options = penSSL::SSL::OP_NO_SSLv2 + OpenSSL::SSL::OP_NO_SSLv3 + OpenSSL::SSL::OP_NO_COMPRESSION
        end

        request = Net::HTTP::Get.new(uri.request_uri)
        response = http.request(request)

        if options[:parse_json]
          JSON(response.body).with_indifferent_access
        else
          response.body
        end
      end

      # NOTE: This is very much tailored to handling Stellar requests.
      def post_response(url, opts = {})
        options = {
          force_sslv3: false,
          parse_json: true,
          data: {}
        }.merge(opts)

        uri = URI.parse(url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true

        if options[:force_sslv3]
          http.ssl_version = :SSLv3
        else
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        end

        request = Net::HTTP::Post.new(uri.request_uri)
        request.content_type = 'application/x-www-form-urlencoded'
        request.body = options[:data].to_json

        begin
          response = http.request(request)
        rescue EOFError => e
        end

        if response
          if options[:parse_json]
            JSON(response.body).with_indifferent_access
          else
            response.body
          end
        else
          {
            result: {
              status: 'error'
            }
          }
        end
      end

      # Implemented methods
      def info(address)
        raise NotImplementedError.new("You must implment #{name}#info")
      end

      def balance(address)
        raise NotImplementedError.new("You must implment #{name}#balances")
      end

      def first_tx_at(address)
        raise NotImplementedError.new("You must implment #{name}#first_tx_at")
      end

      def valid?(address)
        raise NotImplementedError.new("You must implment #{name}#valid?")
      end

      # Conversions
      # Currencies need to implement conversion methods for currencies that are
      # not themselves.
      def to_btc(value)
        value.to_f
      end

      def to_doge(value)
        value.to_f
      end

      def to_ltc(value)
        value.to_f
      end

      def to_str(value)
        value.to_f
      end

      def to_vtc(value)
        value.to_f
      end

      def to_usd(value)
        cc = CurrencyConversion.find_by_name(currency_name)
        value.to_f * cc.to_usd.to_f
      end

      def to_eur(value)
        cc = CurrencyConversion.find_by_name(currency_name)
        value.to_f * cc.to_eur.to_f
      end

      def to_gbp(value)
        cc = CurrencyConversion.find_by_name(currency_name)
        value.to_f * cc.to_gbp.to_f
      end

      def to_jpy(value)
        cc = CurrencyConversion.find_by_name(currency_name)
        value.to_f * cc.to_jpy.to_f
      end

    end
  end
end
