require 'tasks/helpers/rake_logger'

namespace :currency_conversions do

  task populate: :environment do
    RakeLogger.log "=== Populating Currency Conversions ==="

    CurrencyConversion.create!(name: 'Bitcoin') unless CurrencyConversion.find_by_name('Bitcoin')
    CurrencyConversion.create!(name: 'Dogecoin', cryptsy_id: 132) unless CurrencyConversion.find_by_name('Dogecoin')
    CurrencyConversion.create!(name: 'Litecoin', cryptsy_id: 3) unless CurrencyConversion.find_by_name('Litecoin')
    CurrencyConversion.create!(name: 'Stellar', justcoin_id: 'BTCSTR') unless CurrencyConversion.find_by_name('Stellar')
    CurrencyConversion.create!(name: 'Vertcoin', cryptsy_id: 151) unless CurrencyConversion.find_by_name('Vertcoin')

    CurrencyConversion.find_each do |cc|
      RakeLogger.log "Caching data for: #{cc.name}"
      cc.cache_to_btc
      cc.cache_to_usd
    end

    RakeLogger.log '~ ALL DONE ~'
  end

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
