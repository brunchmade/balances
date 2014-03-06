object @address

attributes :currency

node(:currency_image_path) do |address|
  image_path "currencies/#{address.currency.downcase}@2x.png"
end
