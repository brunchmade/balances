class UserMailer < ActionMailer::Base

  default from: 'Balances Team <team@balances.io>'
  default template_path: 'mailer'
  layout 'mailer'

  def welcome(user_id)
    @user = User.find(user_id)
    @name = @user.display_name
    @subject = "Welcome to Balances, #{@name}!"

    mail(
      to: @user.email,
      subject: @subject
    )
  end

  def twofactor_enabled(user_id)
    @user = User.find(user_id)

    mail(
      to: @user.email,
      subject: 'Two-Factor Authentication Enabled'
    )
  end

  def twofactor_disabled(user_id)
    @user = User.find(user_id)

    mail(
      to: @user.email,
      subject: 'Two-Factor Authentication Disabled'
    )
  end

end
