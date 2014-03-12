require 'tasks/helpers/rake_logger'

namespace :migrations do

  task populate_currency_conversions: :environment do
    RakeLogger.log "=== Populating Currency Conversions ==="

    CurrencyConversion.create!(name: 'Bitcoin') unless CurrencyConversion.find_by_name('Bitcoin')
    CurrencyConversion.create!(name: 'Dogecoin', crypsty_id: 132) unless CurrencyConversion.find_by_name('Dogecoin')
    CurrencyConversion.create!(name: 'Litecoin', crypsty_id: 3) unless CurrencyConversion.find_by_name('Litecoin')

    CurrencyConversion.find_each do |cc|
      RakeLogger.log "Caching data for: #{cc.name}"
      cc.cache_to_btc
      cc.cache_to_usd
    end

    RakeLogger.log '~ ALL DONE ~'
  end

end
