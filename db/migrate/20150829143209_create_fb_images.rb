class CreateFbImages < ActiveRecord::Migration
  def change
    create_table :fb_images do |t|
      t.bigint :fb_id
      t.bigint :from
      t.string  :from_name
      t.datetime :photo_created_at
      t.text :images
      t.text :picture
      t.bigint :place_id
      t.string :place_name
      t.text :place_location
      t.text :source
      t.integer :original_height
      t.integer :original_width
      t.text :tags
      t.text :comments
      t.text :links
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
