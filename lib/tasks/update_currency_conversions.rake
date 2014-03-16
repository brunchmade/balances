require 'tasks/helpers/rake_logger'

namespace :update do

  task currency_conversions: :environment do
    RakeLogger.log "=== Updating Currency Conversions ==="

    CurrencyConversion.find_each do |cc|
      RakeLogger.log "Caching data for: #{cc.name}"
      cc.cache_to_btc # Must be first
      cc.cache_to_usd # Must come before other fiat currencies
      cc.cache_to_eur
      cc.cache_to_gbp
      cc.cache_to_jpy
    end

    RakeLogger.log '~ ALL DONE ~'
  end

end
