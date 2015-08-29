class Image < ActiveRecord::Base

  has_attached_file :avatar, {
       :storage => :s3,
       :s3_credentials => Rails.root.join("config","s3.yml"),
       :path => ":class/:style/:hash.:extension",
       :hash_secret => YAML.load_file(Rails.root.join("config","s3.yml"))[Rails.env]["hash_secret"]
  }

  belongs_to :imageable, :polymorphic => true

  validates_attachment :avatar, :presence => true, :content_type => { :content_type => ["image/jpeg", "image/jpg", "image/gif", "image/png"] }, :size => { :in => 0..3.megabyte }
  validates :imageable_id, :imageable_type, presence: true
end
