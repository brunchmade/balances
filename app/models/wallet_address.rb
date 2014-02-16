class WalletAddress < ActiveRecord::Base

  validates_presence_of :currency,
                        :public_address,
                        :user_id

  belongs_to :user

  CURRENCIES = {
    bitcoin: {
      name: 'Bitcoin',
      shortname: 'BTC',
      symbol: [1]
    }
  }

end
