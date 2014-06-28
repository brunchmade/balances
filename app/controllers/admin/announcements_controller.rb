class Admin::AnnouncementsController < AdminController

  def new
    @announcement = Announcement.new
  end

  def edit
    @announcement = Announcement.find(params[:id])
  end

  def create
    @announcement = Announcement.new announcement_params

    if @announcement.save
      redirect_to admin_announcements_path, notice: 'Announcement was created.'
    else
      render :new
    end
  end

  def update
    @announcement = Announcement.find(params[:id])

    if @announcement.update_attributes announcement_params
      redirect_to admin_announcements_path, notice: 'The announcement was updated.'
    else
      render :edit
    end
  end

  def destroy
    @announcement = Announcement.find(params[:id])
    @announcement.destroy

    redirect_to admin_announcements_path, notice: 'The announcement was deleted.'
  end

  private

  def announcement_params
    params.require(:announcement).permit(:content)
  end

end
