class Api::Rest::V1::RegistrationsController < Api::Rest::V1::BaseController

  skip_before_filter :validate_auth_token

  respond_to :json

  def create
    @user = User.create(user_params)

    # If user is created, generate a fresh auth token and assume they are
    # logging in for the first time.
    if @user.valid?
      @user.generate_auth_token
      @user.update_attributes! sign_in_count: @user.sign_in_count + 1
    end

    respond_with @user
  end

  # Should only have params[:user][:login] and params[:user][:password] where
  # :login is either an email or an username.
  def sign_in
    conditions = user_params.dup
    password = conditions.delete(:password)
    @user = User.find_first_by_auth_conditions(conditions)
    if @user.valid_password?(password)
      @user.generate_auth_token
      @user.update_attributes! sign_in_count: @user.sign_in_count + 1
      respond_with @user
    else
      render nothing: true, status: :unauthorized
    end
  end

  def sign_out
    if @token = Token.find_by_token(params[:auth_token])
      @token.destroy
      respond_with @token
    else
      render nothing: true, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :email,
      :username,
      :login,
      :password,
      :password_confirmation
    )
  end

end
