class CreateUserDetails < ActiveRecord::Migration
  def change
    create_table :user_details do |t|
      t.integer	:user_id
      t.integer	:imageable_id
      t.string	:imageable_type
      t.integer	:absolute_happy_q
      t.integer	:calculated_happy_q

      t.timestamps null: false
    end
  end
end
