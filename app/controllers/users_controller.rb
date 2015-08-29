class UsersController < ApplicationController
  def social_login
    access_token = params[:access_token] ? params[:access_token] : nil
    email = params[:email] ? params[:email] : nil
    msg = ensure_params(:email, :access_token) and return
    if msg
      error_with_message(msg, 400)
    else
      begin
        @graph = Koala::Facebook::API.new(access_token)
      rescue
        Rails.logger.error(e.message)
        error_with_message(e.message, 500)
      end
      @profile = @graph.get_object("me")
      if User.exists?(:email => email)
        user = User.where(:email => email).first
        if @profile["email"] == user.email
          @token = user.generate_authentication_token
          render "users/social_login.json.jbuilder"
        else
          error_with_message("authentication failed because Facebook email and requested email did not match", 401)
        end
      else
        user = User.new(:email => email)
        user.password = "password123"
        if user.valid?
          user.fb_token = access_token
          user.save
          @token = user.generate_authentication_token
          render "users/social_login.json.jbuilder"
        else
          error_with_message(error_messages_from_model(user), 400)
        end
      end
    end
  end

  def sync
    ensure_params(:access_token) and return
    user = User.where(:authentication_token => params[:access_token]).first
    if user
      begin
        @graph = Koala::Facebook::API.new(user.fb_token)
      rescue
        Rails.logger.error(e.message)
        error_with_message(e.message, 500)
      end
      @images = @graph.get_object("me/photos")
      FbImage.sync_data(@images,user)
    else
      error_with_message("User not found", 400)
    end
    render "users/sync.json.jbuilder"
  end

  def images
    @images = Image.where("user_id = ?",current_user.id)
    @image_path = params[:image_path]
    if request.get?
      render "users/images_get.json.jbuilder"
    elsif request.post?
      if params[:image_data].present? && CommonHelper::ALLOWED_IMAGE_FORMATS.include?(params[:image_format].strip.downcase)
        @image = Image.new
        @image.imageable_id = current_user.id
        @image.imageable_type = 'User'

        temp_file_name = "tmp/uploads/#{SecureRandom.hex(6).to_s}"
        temp_file_name += "."+params[:image_format].strip.downcase
        temp_image_data = params[:image_data]

        #Decoding the temp image data
        File.open(Rails.root.join(temp_file_name),"wb") do |file|
          file.binmode
          file.write(Base64.decode64(temp_image_data))
        end

        @image.avatar =  File.open(Rails.root.join(temp_file_name))
        if @image.save
          File.delete(Rails.root.join(temp_file_name))
          render "users/images_post.json.jbuilder"
        else
          File.delete(Rails.root.join(temp_file_name))
          error_with_message(error_messages_from_model(@image), 400)
        end
        #grab the image and pop it into the database
      else
        error_with_message("Image Data has not be passed or format not allowed", 400)
      end
    end
  end
end
