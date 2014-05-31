class Address < ActiveRecord::Base

  attr_accessor :is_valid

  validates_presence_of :currency,
                        :user_id
  with_options unless: Proc.new { |a| a.integration.present? } do |address|
    address.validates :public_address, presence: true, uniqueness: { scope: :currency }
    address.validate :valid_address
  end

  belongs_to :user

  scope :integrations, where("COALESCE(integration, '') <> ''")
  scope :nonintegrations, where("COALESCE(integration, '') = ''")

  before_save :clean_attributes

  CURRENCIES = [
    Currencies::Bitcoin,
    Currencies::Dogecoin,
    Currencies::Litecoin,
  ]

  INTEGRATIONS = [
    Integrations::Coinbase,
  ]

  def get_currency
    "Currencies::#{currency}".constantize
  end

  def get_integration
    "Integrations::#{integration}".constantize
  end

  def detect_currency
    first_bit = public_address[0]
    currency = CURRENCIES.detect { |c| c.symbols.any? { |s| s == first_bit} }
    if currency
      self.currency = currency.currency_name
    end
  end

  def display_name
    self.name.present? ? self.name : self.public_address
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
