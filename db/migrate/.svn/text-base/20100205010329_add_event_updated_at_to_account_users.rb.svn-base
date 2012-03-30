class AddEventUpdatedAtToAccountUsers < ActiveRecord::Migration
  def self.up
    add_column :account_users, :event_updated_at, :datetime
  end

  def self.down
    remove_column :account_users, :event_updated_at
  end
end
