class CoinbaseController < ApplicationController

  before_filter :authenticate_user!
  before_filter :set_client

  def auth
    # If token already exists, attempt to refresh it.
    if token = current_user.tokens.where(provider: :coinbase).first
      begin
        access_token = OAuth2::AccessToken.new(@client, token.token, {
          expires_at: token.expires_at,
          refresh_token: token.refresh_token
        })
        refreshed_access_token = access_token.refresh!
        expires_at = get_expires_at(refreshed_access_token)
        coinbase_user = JSON.parse(refreshed_access_token.get('/api/v1/users').body)
        coinbase_user = coinbase_user['users'][0]['user']

        update_or_create_coinbase_address coinbase_user

        token.update_attributes(
          expires_at: expires_at,
          refresh_token: refreshed_access_token.refresh_token,
          token: refreshed_access_token.token
        )

        redirect_to addresses_path

      rescue OAuth2::Error => e
        redirect_to_auth_url
      end

    # No previous token found so create a new one.
    else
      redirect_to_auth_url
    end
  end

  def callback
    if params[:code].present?
      access_token = @client.auth_code.get_token(params[:code], redirect_uri: ENV['COINBASE_CALLBACK_URL'])
      expires_at = get_expires_at(access_token)
      coinbase_user = JSON.parse(access_token.get('/api/v1/users').body)
      coinbase_user = coinbase_user['users'][0]['user']

      update_or_create_coinbase_address coinbase_user

      # Update or create Coinbase auth token
      if token = current_user.tokens.where(provider: :coinbase).first
        token.update_attributes(
          expires_at: expires_at,
          refresh_token: access_token.refresh_token,
          token: access_token.token
        )
      else
        current_user.tokens.create(
          expires_at: expires_at,
          provider: :coinbase,
          provider_uid: coinbase_user['id'],
          refresh_token: access_token.refresh_token,
          token: access_token.token
        )
      end
    end

    redirect_to addresses_path
  end

  private

  def get_expires_at(access_token)
    if access_token.expires_at
      Time.at(access_token.expires_at).to_datetime
    elsif access_token.expires_in
      (Time.now() + access_token.expires_in).to_datetime
    else
      nil
    end
  end

  def set_client
    @client = OAuth2::Client.new(
      ENV['COINBASE_CLIENT_ID'],
      ENV['COINBASE_CLIENT_SECRET'],
      site: 'https://coinbase.com'
    )
  end

  def update_or_create_coinbase_address(coinbase_user)
    if coinbase_address = current_user.addresses.where(integration: Integrations::Coinbase.integration_name, integration_uid: coinbase_user['id']).first
      coinbase_address.update_attributes(
        balance: coinbase_user['balance']['amount'],
        balance_btc: coinbase_user['balance']['amount']
      )
    else
      AddressService.create(
        balance: coinbase_user['balance']['amount'],
        currency: Currencies::Bitcoin.currency_name,
        integration: Integrations::Coinbase.integration_name,
        integration_uid: coinbase_user['id'],
        name: Integrations::Coinbase.integration_name,
        user_id: current_user.id
      )
    end
  end

  def redirect_to_auth_url
    auth_url = @client.auth_code.authorize_url({
      redirect_uri: ENV['COINBASE_CALLBACK_URL']
    })
    auth_url += '&scope=balance+user'

    # Development has a special redirect_url based on the Coinbase API.
    # https://coinbase.com/docs/api/authentication
    #
    # This requires manually entering auth_code in the console and faking the
    # redirection to the callback url.
    if Rails.env.development?
      uri = URI.parse(auth_url)
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Get.new(uri.request_uri)
      response = http.request(request)
      `open "#{auth_url}"`
      print "Enter the code returned in the URL: "
      code = STDIN.readline.chomp
      redirect_to coinbase_callback_path(code: code)
    else
      redirect_to auth_url
    end
  end

end
