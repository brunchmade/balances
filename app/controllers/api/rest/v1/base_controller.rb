class Api::Rest::V1::BaseController < ApplicationController

  protect_from_forgery with: :null_session
  before_filter :validate_auth_token

  protected

  def validate_auth_token
    if params[:auth_token].present? && (token = Token.find_by_token(params[:auth_token]))
      @current_user = User.find(token.user_id)
    else
      render nothing: true, status: :unauthorized
    end
  end

end
