class AddressesController < ApplicationController
  require 'csv'

  before_filter :authenticate_user!
  skip_before_action :verify_authenticity_token, only: [:import]

  respond_to :json
  respond_to :html, only: [:index, :show, :import]

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
        @addresses.order("NULLIF(LOWER(name), '') ASC")
      when 'coins'
        @addresses.order("balance DESC")
      when 'balance'
        @addresses.order("balance_btc DESC")
      when 'currency'
        @addresses.order("currency ASC, NULLIF(LOWER(name), '') ASC")
      else
        @addresses.order("NULLIF(LOWER(name), '') ASC")
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
    @address = AddressService.create(address_create_params)
    respond_with @address
  end

  def update
    if @address = current_user.addresses.where(id: params[:id]).first
      @address.update_attributes address_update_params
    end

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

  def import
    if params[:import_file].present? && params[:import_file].original_filename.match(/\.csv$/i)
      CSV.foreach(params[:import_file].path, headers: true) do |row|
        data = row.to_hash
        address = Address.new(
          public_address: data['Address'],
          name: data['Label'],
          user_id: current_user.id
        )
        address.info
        AddressService.create address.attributes if address.is_valid
      end
      redirect_to addresses_path
    else
      redirect_to root_path
    end
  end

  private

  def address_create_params
    params.require(:address).permit(
      :balance,
      :currency,
      :first_tx_at,
      :name,
      :public_address,
    ).merge(user_id: current_user.id)
  end

  def address_update_params
    params.require(:address).permit(
      :name,
      :notes,
    )
  end

end
