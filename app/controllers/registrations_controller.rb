class RegistrationsController < Devise::RegistrationsController

  def edit
    if params[:tfa_success].present?
      UserMailer.twofactor_enabled(current_user.id).deliver!
    end

    super
  end

end
