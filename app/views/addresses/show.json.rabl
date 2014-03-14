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

node(:balance) { |address| Currencies::Base.trim_trailing_zeros(address.balance) }
node(:balance_btc) { |address| address.get_currency.to_btc(address.balance) }
node(:balance_doge) { |address| address.get_currency.to_doge(address.balance) }
node(:balance_ltc) { |address| address.get_currency.to_ltc(address.balance) }
