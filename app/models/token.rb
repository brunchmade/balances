class Token < ActiveRecord::Base

  validates_presence_of :user_id,
                        :provider,
                        :token

  belongs_to :user

  scope :balances_mobile, where(provider: :balances_mobile)
  scope :coinbase, where(provider: :coinbase)

end
