class AdminController < ApplicationController

  before_filter :authorize_admin

  def stats
    @admins = User.where(is_admin: true)
    @users = User.where(is_admin: false)
    @addresses = Address.where('user_id NOT IN (?)', @admins.pluck(:id))
  end

  private

  def authorize_admin
    unless user_signed_in? && current_user.is_admin
      redirect_to root_path
    end
  end

end
