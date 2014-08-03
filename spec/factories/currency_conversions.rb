# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :currency_conversion do
    name "MyText"
    cryptsy_id 1
    to_btc "9.99"
    to_usd "9.99"
  end
end
