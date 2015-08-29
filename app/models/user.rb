class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :images, :as => :imageable, dependent: :destroy

  def generate_authentication_token
    if !auth_token_expired? && authentication_token.present?
      return self.authentication_token, self.authentication_token_valid_till
    else
      token = ""
      loop do
        token = Devise.friendly_token
        unless User.where(authentication_token: token).first
        break token
        end
      end
      self.authentication_token = token
      self.authentication_token_valid_till = Time.zone.now + 90.days
      self.save
      return token, self.authentication_token_valid_till
    end
  end
end
