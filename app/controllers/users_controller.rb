class UsersController < ApplicationController

  before_filter :authenticate_user!

  def disable_twofactor
    current_user.otp_secret_key = nil
    current_user.has_two_factor_enabled = false
    current_user.save
    redirect_to settings_path, flash: {email: 'Two-factor authentication disabled.'}
  end

  def enable_twofactor
    if current_user.email.present?
      current_user.otp_secret_key = ROTP::Base32.random_base32
      current_user.has_two_factor_enabled = true
      current_user.save
      redirect_to users_twofactor_qr_path
    else
      redirect_to settings_path, flash: {email: 'Email address required to enable two-factor authentication.'}
    end
  end

  def twofactor_qr
    @provisioning_uri = current_user.provisioning_uri(current_user.email, issuer: 'Balances.io')
    @qrCode = RQRCode::render_qrcode(
      @provisioning_uri,
      :svg,
      {
        unit: 4
      }
    )
  end

end
