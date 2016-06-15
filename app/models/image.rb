class Image < ActiveRecord::Base
  belongs_to :micropost
  mount_uploader :file, ImageUploader
end
