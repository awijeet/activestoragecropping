class ProfilesController < ApplicationController
  before_action :set_profile, only: %i[ show edit update destroy ]
  require "open-uri"
  # GET /profiles or /profiles.json
  def index
    @profiles = Profile.all
  end

  # GET /profiles/1 or /profiles/1.json
  def show
    if @profile.image.attached?
        @profile.update_column(:image_rendered, true)
    end
  end

  # GET /profiles/new
  def new
    @profile = Profile.new
  end

  # GET /profiles/1/edit
  def edit
    if @profile.image.attached?
        @profile.update_column(:image_rendered, true)
    end
  end

  # POST /profiles or /profiles.json
  def create
    @profile = Profile.new(profile_params)

    respond_to do |format|
      if @profile.save
        format.html { redirect_to @profile, notice: "Profile was successfully created." }
        format.json { render :show, status: :created, location: @profile }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /profiles/1 or /profiles/1.json
  def update
    crop_x = params[:profile][:crop_x]
    crop_y = params[:profile][:crop_y]
    crop_w = params[:profile][:crop_w]
    crop_h = params[:profile][:crop_h]
    content_for = params[:profile][:content_for]
    image_url = params[:profile][:image_url]
    @close_model = false;
    if content_for.blank?
      respond_to do |format|
        if @profile.update(profile_params)
          format.js
          format.html { redirect_to @profile, notice: "Profile was successfully updated." }
          format.json { render :show, status: :ok, location: @profile }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @profile.errors, status: :unprocessable_entity }
        end
      end
    else
      @profile.update_column(:image_rendered, false)
      HardWorkerWorker.perform_async(@profile.id, image_url, crop_w, crop_h, crop_x, crop_y, '470x470')
      @close_model = true;
      respond_to do |format|
        format.js
      end
    end
  end


  # DELETE /profiles/1 or /profiles/1.json
  def destroy
    @profile.destroy
    respond_to do |format|
      format.html { redirect_to profiles_url, notice: "Profile was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_profile
      @profile = Profile.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def profile_params
      params.require(:profile).permit(:name, :city, :image, :crop_x, :crop_y, :crop_w, :crop_h, :content_for, :image_url)
    end

    # def resize_with_crop image_url, crop_w, crop_h, crop_x, crop_y
    #   require "open-uri"
    #   extension = image_url.split('.').last
    #   current_time = Time.now.to_i.to_s
    #   file_name = Rails.root.join('tmp', "#{current_time}.#{extension}")
    #   cropped_file_name = Rails.root.join('tmp', "cropped_#{current_time}.#{extension}")
    #   open(image_url) do |image|
    #     File.open(file_name, "wb") do |file|
    #       file.write(image.read)
    #     end
    #   end
    #   `convert file_name  -resize 470x470 -crop 359x177+58+153 +repage cropped_file_name`
    #   # img
    # end

end
