class Api::Rest::V1::AddressesController < Api::Rest::V1::BaseController

  respond_to :json

  def create
    @address = Address.create(address_params)
    respond_with @address
  end

  private

  def address_params
    params.require(:address).permit(
      :public_address,
      :currency,
      :name
    )
  end

end
