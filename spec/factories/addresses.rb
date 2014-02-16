# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :address do
    public_address "MyText"
    name "MyText"
    user_id 1
  end
end
