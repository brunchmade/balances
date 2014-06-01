object @user

attributes :id,
           :display_name,
           :email,
           :username

node(:balance_btc) do |user|
  total = user.addresses.bitcoin.inject(0) { |sum, address| sum + address.balance }
  rounded = ActiveSupport::NumberHelper.number_to_rounded(total, precision: 8, strip_insignificant_zeros: true)
  ActiveSupport::NumberHelper.number_to_delimited(rounded)
end

node(:balance_doge) do |user|
  total = user.addresses.dogecoin.inject(0) { |sum, address| sum + address.balance }
  rounded = ActiveSupport::NumberHelper.number_to_rounded(total, precision: 8, strip_insignificant_zeros: true)
  ActiveSupport::NumberHelper.number_to_delimited(rounded)
end

node(:balance_ltc) do |user|
  total = user.addresses.litecoin.inject(0) { |sum, address| sum + address.balance }
  rounded = ActiveSupport::NumberHelper.number_to_rounded(total, precision: 8, strip_insignificant_zeros: true)
  ActiveSupport::NumberHelper.number_to_delimited(rounded)
end

node(:total_btc) do |user|
  total = user.addresses.inject(0) { |sum, address| sum + address.get_currency.to_btc(address.balance) }
  rounded = ActiveSupport::NumberHelper.number_to_rounded(total, precision: 8, strip_insignificant_zeros: true)
  ActiveSupport::NumberHelper.number_to_delimited(rounded)
end

node(:total_doge) do |user|
  total = user.addresses.inject(0) { |sum, address| sum + address.get_currency.to_doge(address.balance) }
  rounded = ActiveSupport::NumberHelper.number_to_rounded(total, precision: 8, strip_insignificant_zeros: true)
  ActiveSupport::NumberHelper.number_to_delimited(rounded)
end

node(:total_ltc) do |user|
  total = user.addresses.inject(0) { |sum, address| sum + address.get_currency.to_ltc(address.balance) }
  rounded = ActiveSupport::NumberHelper.number_to_rounded(total, precision: 8, strip_insignificant_zeros: true)
  ActiveSupport::NumberHelper.number_to_delimited(rounded)
end

node(:total_usd) do |user|
  total = user.addresses.inject(0) { |sum, address| sum + address.get_currency.to_usd(address.balance) }
  rounded = ActiveSupport::NumberHelper.number_to_rounded(total, precision: 2)
  ActiveSupport::NumberHelper.number_to_delimited(rounded)
end

node(:total_eur) do |user|
  total = user.addresses.inject(0) { |sum, address| sum + address.get_currency.to_eur(address.balance) }
  rounded = ActiveSupport::NumberHelper.number_to_rounded(total, precision: 2)
  ActiveSupport::NumberHelper.number_to_delimited(rounded)
end

node(:total_gbp) do |user|
  total = user.addresses.inject(0) { |sum, address| sum + address.get_currency.to_gbp(address.balance) }
  rounded = ActiveSupport::NumberHelper.number_to_rounded(total, precision: 2)
  ActiveSupport::NumberHelper.number_to_delimited(rounded)
end

node(:total_jpy) do |user|
  total = user.addresses.inject(0) { |sum, address| sum + address.get_currency.to_jpy(address.balance) }
  rounded = ActiveSupport::NumberHelper.number_to_rounded(total, precision: 2)
  ActiveSupport::NumberHelper.number_to_delimited(rounded)
end
