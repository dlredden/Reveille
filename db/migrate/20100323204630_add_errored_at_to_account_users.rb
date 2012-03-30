class AddErroredAtToAccountUsers < ActiveRecord::Migration
  def self.up
    add_column :account_users, :errored_at, :datetime
  end

  def self.down
    remove_column :account_users, :errored_at
  end
end
