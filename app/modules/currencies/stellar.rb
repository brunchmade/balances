module Currencies
  class Stellar < Base

    API = 'https://live.stellar.org:9002'
    CURRENCY_NAME = 'Stellar'
    SHORT_NAME = 'STR'
    SYMBOLS = ['g']

    class << self

      def info(address)
        response = post_response(API, {
          data: {
            method: 'account_info',
            params: [{
              account: address
            }]
          }
        })
        info = {}.with_indifferent_access
        if response[:result][:status] == 'success'
          # Diving by 1000000 because an account with 60000 returns as 60000999975
          info[:balance] = response[:result][:account_data][:Balance].to_f / 1000000
          info[:is_valid] = response[:result][:status] == 'success'
          info[:first_tx_at] = first_tx_at(address)
        end
        info
      end

      def balance(address)
        response = post_response(API, {
          data: {
            method: 'account_info',
            params: [{
              account: address
            }]
          }
        })
        if response[:result][:status] == 'success'
          # Diving by 1000000 because an account with 60000 returns as 60000999975
          response[:result][:account_data][:balance] / 1000000
        end
      end

      # TODO: This API is still in its infancy. Check back to see if the 'forward'
      #   flag works so you only need to grab one record. Also their datetime
      #   stamps are 20 years off.
      def first_tx_at(address)
        response = post_response(API, {
          data: {
            method: 'account_tx',
            params: [{
              account: address,
              ledger_min: 0
              # forward: true
            }]
          }
        })
        if response[:result][:status] == 'success'
          tx = response[:result][:transactions].last
          Time.at(tx[:tx][:date] + 20.years.to_i).utc.to_datetime
        end
      end

      def valid?(address)
        response = post_response(API, {
          data: {
            method: 'account_info',
            params: [{
              account: address
            }]
          }
        })
        response[:result][:status] == 'success'
      end

      # Conversions
      def to_btc(value)
        cc = CurrencyConversion.find_by_name(currency_name)
        value.to_f * cc.to_btc.to_f
      end

      def to_doge(value)
        value_btc = to_btc(value)
        Currencies::Bitcoin.to_doge value_btc
      end

      def to_ltc(value)
        value_btc = to_btc(value)
        Currencies::Bitcoin.to_ltc value_btc
      end

      def to_vtc(value)
        value_btc = to_btc(value)
        Currencies::Bitcoin.to_ltc value_btc
      end

    end
  end
end
