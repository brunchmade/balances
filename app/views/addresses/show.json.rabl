object @address

attributes :id,
           :user_id,
           :currency,
           :name,
           :public_address

node(:shortname) { |address| address.get_currency.short_name }

node(:currency_image_path) do |address|
  image_path "currencies/#{address.currency.downcase}@2x.png"
end

node(:balance) do |address|
  rounded = ActiveSupport::NumberHelper.number_to_rounded(address.balance, precision: 8, strip_insignificant_zeros: true)
  ActiveSupport::NumberHelper.number_to_delimited(rounded)
end

node(:balance_btc) do |address|
  rounded = ActiveSupport::NumberHelper.number_to_rounded(address.get_currency.to_btc(address.balance), precision: 8, strip_insignificant_zeros: true)
  ActiveSupport::NumberHelper.number_to_delimited(rounded)
end

node(:balance_doge) do |address|
  rounded = ActiveSupport::NumberHelper.number_to_rounded(address.get_currency.to_doge(address.balance), precision: 8, strip_insignificant_zeros: true)
  ActiveSupport::NumberHelper.number_to_delimited(rounded)
end

node(:balance_ltc) do |address|
  rounded = ActiveSupport::NumberHelper.number_to_rounded(address.get_currency.to_ltc(address.balance), precision: 8, strip_insignificant_zeros: true)
  ActiveSupport::NumberHelper.number_to_delimited(rounded)
end

node(:balance_usd) do |address|
  rounded = ActiveSupport::NumberHelper.number_to_rounded(address.get_currency.to_usd(address.balance), precision: 2)
  ActiveSupport::NumberHelper.number_to_delimited(rounded)
end
