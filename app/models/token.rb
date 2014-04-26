class Token < ActiveRecord::Base

  validates_presence_of :user_id,
                        :provider,
                        :token

  belongs_to :user

end
