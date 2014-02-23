class Address < ActiveRecord::Base

  validates_presence_of :currency,
                        :public_address,
                        :user_id
  validates :public_address, uniqueness: { scope: :currency }

  belongs_to :user

  CURRENCIES = {
    bitcoin: {
      name: 'Bitcoin',
      shortname: 'BTC',
      symbol: ['1']
    }
  }

  def detect_currency
    first_bit = public_address[0]
    matching_currencies = CURRENCIES.values.select { |c| c[:symbol].any? { |s| s == first_bit } }
    matching_currencies.map { |mc| mc[:name] }
  end

end
