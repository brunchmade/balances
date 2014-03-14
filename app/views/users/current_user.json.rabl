object @user

attributes :id,
           :email,
           :username

node(:total_btc) do |user|
  total = user.addresses.inject(0) do |sum, address|
    sum + address.get_currency.to_btc(address.balance)
  end
  Currencies::Base.trim_trailing_zeros(total)
end

node(:total_doge) do |user|
  total = user.addresses.inject(0) do |sum, address|
    sum + address.get_currency.to_doge(address.balance)
  end
  Currencies::Base.trim_trailing_zeros(total)
end

node(:total_ltc) do |user|
  total = user.addresses.inject(0) do |sum, address|
    sum + address.get_currency.to_ltc(address.balance)
  end
  Currencies::Base.trim_trailing_zeros(total)
end

node(:total_usd) do |user|
  total = user.addresses.inject(0) do |sum, address|
    sum + address.get_currency.to_usd(address.balance)
  end
  Currencies::Base.trim_trailing_zeros(total)
end
