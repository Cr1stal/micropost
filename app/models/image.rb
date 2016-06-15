class Image < ActiveRecord::Base
  belongs_to :micropost
  mount_uploader :image, ImageUploader
end
