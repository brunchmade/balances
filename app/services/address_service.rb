class AddressService
  class << self

    def create(attrs)
      address = Address.new(attrs)
      if address.balance.blank?
        address.balance = address.get_currency.balance(address.public_address)
      end
      address.balance_btc = address.get_currency.to_btc(address.balance)
      address.save
      address
    end

  end
end
