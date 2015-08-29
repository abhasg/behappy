class CreateUserDetails < ActiveRecord::Migration
  def change
    create_table :user_details do |t|
      t.integer :user_id
      t.string :name
      t.date :dob
      t.integer :contact
      t.string :gender

      t.timestamps null: false
    end
  end
end
