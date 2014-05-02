require 'open-uri'

class CurrencyConversion < ActiveRecord::Base

  def cache_to_btc
    if self.crypsty_id
      currency = "Currencies::#{self.name}".constantize
      url = "http://pubapi.cryptsy.com/api.php?method=singlemarketdata&marketid=#{self.crypsty_id}"
      response = open(url) { |v| JSON(v.read).with_indifferent_access }
      self.to_btc = response[:return][:markets][currency.short_name.to_sym][:lasttradeprice].to_f
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
