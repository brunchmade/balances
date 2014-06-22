require 'tasks/helpers/rake_logger'

namespace :addresses do

  task update_balances: :environment do
    RakeLogger.log "=== Updating Address Balances ==="

    Address.nonintegrations.find_each do |address|
      RakeLogger.log "Updating address: #{address.id}"
      currency = address.get_currency
      address.balance = currency.balance(address.public_address)
      address.balance_btc = currency.to_btc(address.balance)
      address.save
    end

    RakeLogger.log '~ ALL DONE ~'
  end

  task set_first_tx_at: :environment do
    RakeLogger.log "=== Setting Address First Transaction At ==="

    Address.nonintegrations.find_each do |address|
      RakeLogger.log "Updating address: #{address.id}"
      currency = address.get_currency
      info = currency.info(address.public_address)
      address.first_tx_at = info[:first_tx_at]
      address.save
    end

    RakeLogger.log '~ ALL DONE ~'
  end

end
