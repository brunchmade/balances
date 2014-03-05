class Address < ActiveRecord::Base

  validates_presence_of :currency,
                        :public_address,
                        :user_id
  validates :public_address, uniqueness: { scope: :currency }
  validate :valid_address

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

  private

  def valid_address
    unless get_currency.valid?(public_address)
      errors.add(:public_address, 'is invalid')
    end
  end

end
