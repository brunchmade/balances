class Token < ActiveRecord::Base

  validates_presence_of :user_id,
                        :token

  belongs_to :user

end
