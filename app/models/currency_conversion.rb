require 'open-uri'

class CurrencyConversion < ActiveRecord::Base

  def cache_to_btc
    if self.cryptsy_id
      currency = "Currencies::#{self.name}".constantize
      url = "http://pubapi.cryptsy.com/api.php?method=singlemarketdata&marketid=#{self.cryptsy_id}"
      response = open(url) { |v| JSON(v.read).with_indifferent_access }
      self.to_btc = response[:return][:markets][currency.short_name.to_sym][:lasttradeprice].to_f
      self.save
    elsif self.justcoin_id
      currency = "Currencies::#{self.name}".constantize

      url = 'https://justcoin.com/api/v1/markets/'
      uri = URI.parse(url)

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Get.new(uri.request_uri)
      response = http.request(request)

      data = JSON(response.body)
      data_row = data.find { |i| i['id'] == self.justcoin_id }.with_indifferent_access

      self.to_btc = 1 / data_row[:last].to_f
      self.save
    end
  end

  def cache_to_usd
    url = 'https://www.bitstamp.net/api/ticker/'
    response = open(url) { |v| JSON(v.read).with_indifferent_access }
    if self.to_btc
      self.to_usd = response[:last].to_f * self.to_btc
    else
      self.to_usd = response[:last].to_f
    end
    self.save
  end

  def cache_to_eur
    url = 'https://blockchain.info/tobtc?currency=EUR&value=1'
    response = open(url) { |v| v.read }
    self.to_eur = 1 / response.to_f
    self.to_eur *= self.to_btc unless self.name == 'Bitcoin'
    self.save
  end

  def cache_to_gbp
    url = 'https://blockchain.info/tobtc?currency=GBP&value=1'
    response = open(url) { |v| v.read }
    self.to_gbp = 1 / response.to_f
    self.to_gbp *= self.to_btc unless self.name == 'Bitcoin'
    self.save
  end

  def cache_to_jpy
    url = 'https://blockchain.info/tobtc?currency=JPY&value=1'
    response = open(url) { |v| v.read }
    self.to_jpy = 1 / response.to_f
    self.to_jpy *= self.to_btc unless self.name == 'Bitcoin'
    self.save
  end

end
