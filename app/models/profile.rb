class Profile < ApplicationRecord
	has_one_attached :image
	attr_accessor :crop_x, :crop_y, :crop_w, :crop_h, :content_for, :image_url
end
