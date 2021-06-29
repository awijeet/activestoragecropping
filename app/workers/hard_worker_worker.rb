class HardWorkerWorker
  include Sidekiq::Worker
  require "open-uri"
  def perform(profile_id, image_url, crop_w, crop_h, crop_x, crop_y, image_size)
    puts "profile_id = #{profile_id}"
    puts "image_url = #{image_url}"
    puts "crop_w = #{crop_w}"
    puts "crop_h = #{crop_h}"
    puts "crop_x = #{crop_x}"
    puts "crop_y = #{crop_y}"

    profile = Profile.find profile_id
    extension = image_url.split('.').last
      current_time = Time.now.to_i.to_s
      file_name = Rails.root.join('tmp', "#{current_time}.#{extension}")
      cropped_file_name = Rails.root.join('tmp', "cropped_#{current_time}.#{extension}")
      open(image_url) do |image|
        File.open(file_name, "wb") do |file|
          file.write(image.read)
        end
      end
      `convert #{file_name}  -resize #{image_size} -crop 359x177+58+153 +repage #{cropped_file_name}`
      profile.image.attach(
        io: File.open(cropped_file_name),
        filename: "cropped_#{current_time}.#{extension}"
        )
      profile.save(:validate => false)
      profile.update_column(:image_rendered, true)
      File.delete(file_name)
      File.delete(cropped_file_name)
  end
end
