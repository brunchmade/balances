class Address < ActiveRecord::Base

  attr_accessor :is_valid

  validates_presence_of :currency,
                        :public_address,
                        :user_id
  validates :public_address, uniqueness: { scope: :currency }
  validate :valid_address

  belongs_to :user

  before_save :clean_attributes

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
    currency = CURRENCIES.detect { |c| c.symbols.any? { |s| s == first_bit} }
    self.currency = currency.currency_name
  end

  def info
    detect_currency
    info = get_currency.info(public_address)
    self.balance = info[:balance]
    self.is_valid = info[:is_valid]
    info
  end

  private

  def valid_address
    unless get_currency.valid?(public_address)
      errors.add(:public_address, 'is invalid')
    end
  end

  def clean_attributes
    self.public_address.strip! if self.public_address.present?
    self.name.strip! if self.name.present?
  end

end
