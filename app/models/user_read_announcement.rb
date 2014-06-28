class UserReadAnnouncement < ActiveRecord::Base

  validates_presence_of :announcement_id,
                        :user_id

  belongs_to :announcement
  belongs_to :user

end
