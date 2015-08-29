class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception

  def populate_api_version
    @api_version = params[:api_version] || "v3"
  end

  def error_with_message(message="Woah, we punctured a tire! ZoomCar encountered an error.", http_status_code = 400)
    if http_status_code  == 401 && Rails.env.production?
      response.headers["WWW-Authenticate"] = "Basic realm = 'fake'"
      http_status_code = 400
    end
    render inline: "json.errorCode \"#{message}\"; json.error \"#{t(message)}\"; json.status '0'", :status => http_status_code,  type: :jbuilder
    return
  end

  private

  def authenticate_user_from_token!
    Rails.logger.debug(current_user.inspect)
    if current_user && !current_user.auth_token_expired?
      # sign_in current_user, store:false
    else
      error_with_message(:tokenNotFound, 401)
    end

  end

  def current_user
    begin
      @_user_ ||= User.find_by( authentication_token: params[:auth_token].to_s )
    rescue StandardError => e
      Rails.logger.error(e.message)
      return nil
    end
  end

  def ensure_params(*req)
    missing = []
    req.each do |param|
      if params[param].blank?
        missing << param.to_s
      end
    end
    if missing.empty?
      return false
    else
      msg = "Following params are required but missing: " + missing.join(", ")
      error_with_message(msg, 400)
      return true
    end
  end

  def facebook_cookies
    @facebook_cookies ||= Koala::Facebook::OAuth.new
  end
end
