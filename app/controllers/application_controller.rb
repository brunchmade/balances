class ApplicationController < ActionController::Base

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :set_current_user_json
  before_filter :set_current_user_addresses_json
  before_filter :setup_gon

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password) }
  end

  def set_current_user_json
    @current_user_json = Rabl::Renderer.new(
      'users/current_user',
      (current_user || {}),
      view_path: 'app/views',
      format: 'json',
      scope: view_context
    ).render
  end

  def set_current_user_addresses_json
    sorted_addresses = if user_signed_in?
      current_user.addresses.order("NULLIF(name, '') ASC")
    else
      {}
    end
    @current_user_addresses_json = Rabl::Renderer.new(
      'addresses/show',
      sorted_addresses,
      view_path: 'app/views',
      format: 'json',
      scope: view_context
    ).render
  end

  def setup_gon
    gon.user_voice_url = 'http://balances.uservoice.com/forums/244164-suggestions'

    gon.cryptocurrencies = {
      btc: {
        name: Currencies::Bitcoin.currency_name,
        short_name: Currencies::Bitcoin.short_name.downcase,
        short_name_upper: Currencies::Bitcoin.short_name,
      },
      doge: {
        name: Currencies::Dogecoin.currency_name,
        short_name: Currencies::Dogecoin.short_name.downcase,
        short_name_upper: Currencies::Dogecoin.short_name,
      },
      ltc: {
        name: Currencies::Litecoin.currency_name,
        short_name: Currencies::Litecoin.short_name.downcase,
        short_name_upper: Currencies::Litecoin.short_name,
      },
      str: {
        name: Currencies::Stellar.currency_name,
        short_name: Currencies::Stellar.short_name.downcase,
        short_name_upper: Currencies::Stellar.short_name,
      },
      vtc: {
        name: Currencies::Vertcoin.currency_name,
        short_name: Currencies::Vertcoin.short_name.downcase,
        short_name_upper: Currencies::Vertcoin.short_name,
      },
    }

    gon.default_fiat_currency = :usd
    gon.fiat_currencies = {
      usd: {
        name: 'US Dollar',
        short_name: 'usd',
        short_name_upper: 'USD',
        symbol: '$',
      },
      eur: {
        name: 'Euros',
        short_name: 'eur',
        short_name_upper: 'EUR',
        symbol: '€',
      },
      gbp: {
        name: 'Pounds Sterling',
        short_name: 'gbp',
        short_name_upper: 'GBP',
        symbol: '£',
      },
      jpy: {
        name: 'Japanese Yen',
        short_name: 'jpy',
        short_name_upper: 'JPY',
        symbol: '¥',
      },
    }

    gon.currency_conversion = {
      btc: {},
      doge: {},
      ltc: {},
      str: {},
      vtc: {},
    }
    ['usd', 'eur', 'gbp', 'jpy'].each do |fiat_currency|
      key = "to_#{fiat_currency}"

      value = CurrencyConversion.find_by_name('Bitcoin').send(key)
      rounded = ActiveSupport::NumberHelper.number_to_rounded(value, precision: 2)
      gon.currency_conversion[:btc][key] = ActiveSupport::NumberHelper.number_to_delimited(rounded)

      value = CurrencyConversion.find_by_name('Dogecoin').send(key)
      rounded = ActiveSupport::NumberHelper.number_to_rounded(value, precision: 4)
      gon.currency_conversion[:doge][key] = ActiveSupport::NumberHelper.number_to_delimited(rounded)

      value = CurrencyConversion.find_by_name('Litecoin').send(key)
      rounded = ActiveSupport::NumberHelper.number_to_rounded(value, precision: 2)
      gon.currency_conversion[:ltc][key] = ActiveSupport::NumberHelper.number_to_delimited(rounded)

      value = CurrencyConversion.find_by_name('Stellar').send(key)
      rounded = ActiveSupport::NumberHelper.number_to_rounded(value, precision: 4)
      gon.currency_conversion[:str][key] = ActiveSupport::NumberHelper.number_to_delimited(rounded)

      value = CurrencyConversion.find_by_name('Vertcoin').send(key)
      rounded = ActiveSupport::NumberHelper.number_to_rounded(value, precision: 2)
      gon.currency_conversion[:vtc][key] = ActiveSupport::NumberHelper.number_to_delimited(rounded)
    end
  end

end
