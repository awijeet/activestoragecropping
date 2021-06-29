class AjaxController < ApplicationController
  def fetch_image
    @profile = Profile.find params[:profile_id]
    format.js
  end

  def fetch_cropping_status
    @profile = Profile.find params[:profile_id]
    render json: @profile.image_rendered and return
  end

end
