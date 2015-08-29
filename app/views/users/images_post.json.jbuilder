json.set! :status, "1"
json.set! :message, "Image Successfully Saved"
json.set! :image_path, @image_path
json.set! :image_url, @image.avatar.url
json.set! :image_id, @image.id