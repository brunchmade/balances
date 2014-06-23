module Coinbase

  def self.get_client
    OAuth2::Client.new(
      ENV['COINBASE_CLIENT_ID'],
      ENV['COINBASE_CLIENT_SECRET'],
      site: 'https://coinbase.com'
    )
  end

  def self.get_access_token(client, token)
    OAuth2::AccessToken.new(client, token.token, {
      expires_at: token.expires_at,
      refresh_token: token.refresh_token
    })
  end

  def self.get_expires_at(access_token)
    if access_token.expires_at
      Time.at(access_token.expires_at).to_datetime
    elsif access_token.expires_in
      (Time.now() + access_token.expires_in).to_datetime
    else
      nil
    end
  end

end
