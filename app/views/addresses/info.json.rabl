object @address

attributes :currency,
           :is_valid

node(:shortname) do |address|
 address.get_currency.short_name
end

node(:currency_image_path) do |address|
  image_path "currencies/#{address.currency.downcase}@2x.png"
end

node(:balance) { |address| Currencies::Base.trim_trailing_zeros(address.balance) }
