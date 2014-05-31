class ApplicationController < ActionController::Base

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :setup_gon

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password) }
  end

  def setup_gon
    gon.user_voice_url = 'http://balances.uservoice.com/forums/244164-suggestions'

    gon.fiat_currencies = [
      {name: 'US Dollar', short_name: 'usd'},
      {name: 'Euros', short_name: 'eur'},
      {name: 'Pounds Sterling', short_name: 'gbp'},
      {name: 'Japanese Yen', short_name: 'jpy'},
    ]
  end

end
