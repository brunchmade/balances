class Announcement < ActiveRecord::Base

  validates_presence_of :content

  has_many :user_read_announcements, dependent: :destroy

  before_save :clean_attributes

  private

  def clean_attributes
    self.content.strip! if self.content.present?
  end

end
