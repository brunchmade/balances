class Address < ActiveRecord::Base

  validates_presence_of :currency,
                        :public_address,
                        :user_id
  validates :public_address, uniqueness: { scope: :currency }

  belongs_to :user

  CURRENCIES = [
    Currencies::Bitcoin,
    Currencies::Dogecoin,
    Currencies::Litecoin
  ]

  def get_currency
    "Currencies::#{currency}".constantize
  end

  def detect_currency
    first_bit = public_address[0]
    currencies = CURRENCIES.select { |c| c.symbols.any? { |s| s == first_bit} }
    currencies.map { |c| c.currency_name }
  end

end
