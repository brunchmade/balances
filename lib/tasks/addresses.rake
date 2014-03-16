require 'tasks/helpers/rake_logger'

namespace :addresses do

  task update_balances: :environment do
    RakeLogger.log "=== Updating Address Balances ==="

    Address.find_each do |address|
      RakeLogger.log "Updating address: #{address.id}"
      currency = address.get_currency
      address.balance = currency.balance(address.public_address)
      address.balance_btc = currency.to_btc(address.balance)
      address.save
    end

    RakeLogger.log '~ ALL DONE ~'
  end

end
