class AnnouncementsController < ApplicationController

  respond_to :json

  def index
    @announcements = Announcement.where("""
      NOT EXISTS (
        SELECT user_id
        FROM user_read_announcements
        WHERE
          user_id = ? AND
          announcement_id = announcements.id
      )
    """, current_user.id).order('created_at DESC')

    respond_with @announcements
  end

  def mark_as_read
    if Announcement.exists?(params[:announcement_id])
      current_user.user_read_announcements.create(announcement_id: params[:announcement_id])
      render json: {success: {message: 'Announcement marked as read.'}}, status: :ok
    else
      render json: {error: {message: 'Announcement not found.'}}, status: :not_found
    end
  end

end
