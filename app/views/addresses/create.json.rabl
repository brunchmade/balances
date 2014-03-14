object @address

attributes :id,
           :user_id,
           :currency,
           :name,
           :public_address

node(:shortname) do |address|
  address.get_currency.short_name
end

node(:currency_image_path) do |address|
  image_path "currencies/#{address.currency.downcase}@2x.png"
end

node(:balance) { |address| Currencies::Base.trim_trailing_zeros(address.balance) }
