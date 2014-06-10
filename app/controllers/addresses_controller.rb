class AddressesController < ApplicationController

  before_filter :authenticate_user!

  respond_to :json
  respond_to :html, only: [:index, :show]

  def index
    @addresses = current_user.addresses

    @addresses =
      if params[:filter].present? && params[:filter] != 'all'
          @addresses.send(params[:filter])
      else
        @addresses
      end

    @addresses =
      case params[:order]
      when 'name'
        @addresses.order("NULLIF(name, '') ASC")
      when 'coins'
        @addresses.order("balance DESC")
      when 'balance'
        @addresses.order("balance_btc DESC")
      when 'currency'
        @addresses.order("currency ASC, NULLIF(name, '') ASC")
      else
        @addresses.order("NULLIF(name, '') ASC")
      end

    respond_to do |format|
      format.html
      format.json {
        respond_with @addresses
      }
    end
  end

  def show
    redirect_to addresses_path
  end

  def create
    @address = AddressService.create(address_params)
    respond_with @address
  end

  def destroy
    if @address = current_user.addresses.where(id: params[:id]).first
      @address.destroy
    end

    respond_with @address
  end

  def detect_currency
    respond_to do |format|
      format.html { redirect_to addresses_path }
      format.json {
        if params[:public_address].present?
          @address = Address.new(public_address: params[:public_address])
          @address.detect_currency
          respond_with @address
        else
          render nothing: true, status: :bad_request
        end
      }
    end
  end

  def info
    respond_to do |format|
      format.html { redirect_to addresses_path }
      format.json {
        if params[:public_address].present?
          @address = Address.new(public_address: params[:public_address])
          @address.info
          respond_with @address
        else
          render nothing: true, status: :bad_request
        end
      }
    end
  end

  private

  def address_params
    params.require(:address).permit(
      :balance,
      :currency,
      :name,
      :public_address,
    ).merge(user_id: current_user.id)
  end

end
