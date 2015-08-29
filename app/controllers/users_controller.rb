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
        if user.valid?
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

  end
end
