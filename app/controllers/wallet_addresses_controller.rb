class WalletAddressesController < ApplicationController

  before_filter :authenticate_user!

  respond_to :html

  def index
  end

  def show
    redirect_to wallet_addresses_path
  end

  def new
    @wallet_address = WalletAddress.new
  end

  def create
    @wallet_address = WalletAddress.new(wallet_address_params)

    flash[:notice] = if @wallet_address.save
      'Wallet address created successfully!'
    else
      @wallet_address.errors.to_hash
    end

    respond_with @wallet_address
  end

  private

  def wallet_address_params
    params.require(:wallet_address).permit(
      :public_address,
      :currency,
      :name
    ).merge(user_id: current_user.id)
  end

end
