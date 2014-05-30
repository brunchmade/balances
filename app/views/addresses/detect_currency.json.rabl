object @address

attributes :currency

node(:currency_image_path) do |address|
  if address.currency
    image_path "currencies/#{address.currency.downcase}.svg"
  else
    nil
  end
end
