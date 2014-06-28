class AdminController < ApplicationController

  before_filter :authorize_admin

  private

  def authorize_admin
    unless user_signed_in? && current_user.is_admin
      redirect_to root_path
    end
  end

end
