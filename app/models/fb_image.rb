class FbImage < ActiveRecord::Base
  belongs_to :user

  def self.sync_data images, user
    images.each do |profile|
      fb_image = FbImage.where(:fb_id => profile["id"]).first
      fb_image = user.fb_images.build if fb_image.blank?
      fb_image.fb_id = profile["id"]
      if profile["from"]
        fb_image.from = profile["from"]["id"]
        fb_image.from_name = profile["from"]["id"]
      end
      fb_image.photo_created_at = Time.parse(profile["created_time"])
      fb_image.images = profile["images"].to_json
      fb_image.picture = profile["picture"]
      if profile["place"]
        fb_image.place_id = profile["place"]["id"]
        fb_image.place_name = profile["place"]["name"]
        fb_image.place_location = profile["place"]["location"].to_json
      end
      fb_image.source = profile["source"]
      fb_image.original_height = profile["height"]
      fb_image.original_width = profile["width"]
      fb_image.tags = profile["tags"].to_json
      fb_image.save
    end
  end
end
