require 'tasks/helpers/rake_logger'

namespace :currency_conversions do

  task update: :environment do
    RakeLogger.log "=== Updating Currency Conversions ==="

    CurrencyConversion.find_each do |cc|
      RakeLogger.log "Caching data for: #{cc.name}"
      RakeLogger.log "  bitcoin..."
      cc.cache_to_btc # Must be first
      RakeLogger.log "  usd..."
      cc.cache_to_usd # Must come before other fiat currencies
      RakeLogger.log "  eur..."
      cc.cache_to_eur
      RakeLogger.log "  gbp..."
      cc.cache_to_gbp
      RakeLogger.log "  jpy..."
      cc.cache_to_jpy
    end

    RakeLogger.log '~ ALL DONE ~'
  end

end
