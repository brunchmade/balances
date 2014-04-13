object @address

attributes :currency

node(:currency_image_path) do |address|
  if address.currency
    image_path "currencies/#{address.currency.downcase}@2x.png"
  else
    nil
  end
end
