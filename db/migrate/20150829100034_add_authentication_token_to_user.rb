class AddAuthenticationTokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :authentication_token, :string, default: nil
    add_column :users, :authentication_token_valid_till, :datetime

    add_index :users, :authentication_token, :unique => true
  end
end
