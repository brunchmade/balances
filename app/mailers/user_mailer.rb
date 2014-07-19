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

end
