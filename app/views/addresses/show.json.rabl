object @address

attributes :id,
           :user_id,
           :currency,
           :name,
           :public_address

node(:shortname) do |address|
  Address.get_currency(address.currency)[:shortname]
end

node(:currency_image_path) do |address|
  image_path "currencies/#{address.currency.downcase}@2x.png"
end
