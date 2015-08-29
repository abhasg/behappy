json.set! :status, "1"
imageArray = []
json.licenses do
  @images.each do |image|
    imageArray << {:id => image.id,:url => (image.avatar.url)}
  end
  json.array! imageArray
end
json.max_image_size 2*1024*1024
json.image_size_error_msg "Image upload failed due to the size. Please ensure the image is less than 2MB."
if !@images.blank? && @images.order(:avatar_updated_at).last.avatar_updated_at > Time.zone.now - 2.minutes
  json.image_status "Your Image has been uploaded successfully, it will take sometime to reflect here."
end