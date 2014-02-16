class AddressesController < ApplicationController

  before_filter :authenticate_user!

  respond_to :html

  def index
  end

  def show
    redirect_to addresses_path
  end

  def new
    @address = Address.new
  end

  def create
    @address = Address.new(address_params)

    flash[:notice] = if @address.save
      'Address created successfully!'
    else
      @address.errors.to_hash
    end

    respond_with @address
  end

  def detect_currency
    respond_to do |format|
      format.html { redirect_to addresses_path }
      format.json {
        if params[:public_address].present?
          @address = Address.new(public_address: params[:public_address])
          render json: {currency: @address.detect_currency}
        else
          render nothing: true, status: :bad_request
        end
      }
    end
  end

  private

  def address_params
    params.require(:address).permit(
      :public_address,
      :currency,
      :name
    ).merge(user_id: current_user.id)
  end

end
