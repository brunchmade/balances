object @address

attributes :currency,
           :is_valid

node(:shortname) do |address|
 address.get_currency.short_name
end

node(:currency_image_path) do |address|
  image_path "currencies/#{address.currency.downcase}.svg"
end

node(:balance) do |address|
  rounded = ActiveSupport::NumberHelper.number_to_rounded(address.balance, precision: 8, strip_insignificant_zeros: true)
  ActiveSupport::NumberHelper.number_to_delimited(rounded)
end
