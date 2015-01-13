# This is our base mailer class as well as the devise mailer override class.
class DeviseMailer < Devise::Mailer

  default from: 'Balances Team <balancesapp@gmail.com>'
  layout 'mailer'

  def reset_password_instructions(record, token, opts={})
    @user = record
    opts[:subject] = 'Reset Password Instructions'
    opts[:template_path] = 'mailer/devise'
    super
  end

end
