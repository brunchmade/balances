require 'tasks/helpers/rake_logger'

namespace :addresses do

  task update_balances: :environment do
    RakeLogger.log "=== Updating Address Balances ==="

    RakeLogger.log "--- Non-integrations ---"
    Address.nonintegrations.find_each do |address|
      RakeLogger.log "Updating address: #{address.id}"
      currency = address.get_currency
      address.update_attributes(
        balance: currency.balance(address.public_address),
        balance_btc: currency.to_btc(address.balance)
      )
    end

    RakeLogger.log "--- Integrations ---"
    Address.integrations.find_each do |address|
      RakeLogger.log "Updating address: #{address.id}"
      integration = address.get_integration
      if token = address.user.tokens.where(provider: integration.integration_name.downcase).first
        begin
          client = Coinbase::get_client
          access_token = Coinbase::get_access_token(client, token)

          refreshed_access_token = access_token.refresh!
          expires_at = Coinbase::get_expires_at(refreshed_access_token)
          coinbase_user = JSON.parse(refreshed_access_token.get('/api/v1/users').body)
          coinbase_user = coinbase_user['users'][0]['user']

          address.update_attributes(
            balance: coinbase_user['balance']['amount'],
            balance_btc: coinbase_user['balance']['amount']
          )

          token.update_attributes(
            expires_at: expires_at,
            refresh_token: refreshed_access_token.refresh_token,
            token: refreshed_access_token.token
          )
        rescue OAuth2::Error => e
          RakeLogger.log "  FAILED"
        end
      end
    end

    RakeLogger.log '~ ALL DONE ~'
  end

  task set_first_tx_at: :environment do
    RakeLogger.log "=== Setting Address First Transaction At ==="

    RakeLogger.log "--- Non-integrations ---"
    Address.nonintegrations.find_each do |address|
      RakeLogger.log "Updating address: #{address.id}"
      currency = address.get_currency
      info = currency.info(address.public_address)
      address.first_tx_at = info[:first_tx_at]
      address.save
    end

    RakeLogger.log "--- Integrations ---"
    Address.integrations.find_each do |address|
      RakeLogger.log "Updating address: #{address.id}"
      integration = address.get_integration
      if token = address.user.tokens.where(provider: integration.integration_name.downcase).first
        begin
          client = Coinbase::get_client
          access_token = Coinbase::get_access_token(client, token)

          refreshed_access_token = access_token.refresh!
          expires_at = Coinbase::get_expires_at(refreshed_access_token)
          coinbase_accounts = JSON.parse(refreshed_access_token.get('/api/v1/accounts').body)

          address.update_attributes(first_tx_at: coinbase_accounts['accounts'][0]['created_at'])

          token.update_attributes(
            expires_at: expires_at,
            refresh_token: refreshed_access_token.refresh_token,
            token: refreshed_access_token.token
          )
        rescue OAuth2::Error => e
          RakeLogger.log "  FAILED"
        end
      end
    end

    RakeLogger.log '~ ALL DONE ~'
  end

end
