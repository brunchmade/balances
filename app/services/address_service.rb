class AddressService

  def self.create(attrs)
    address = Address.new(attrs)
    if address.save
      address.update_attributes(balance: address.get_currency.balance(address.public_address))
    end
    address
  end

end
