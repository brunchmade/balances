class StaticController < ApplicationController

  def root
    if user_signed_in?
      redirect_to addresses_path
    else
      #render :landing, layout: 'landing'
      render :teaser, layout: false
    end
  end

  def home
    render :landing, layout: 'landing'
  end

  def teaser
    render :teaser, layout: false
  end

  def terms_privacy
  end

end
