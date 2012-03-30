class AddApiTokenToAccountUser < ActiveRecord::Migration
  def self.up
    add_column :account_users, :api_token, :string
  end

  def self.down
    remove_column :account_users, :api_token
  end
end
