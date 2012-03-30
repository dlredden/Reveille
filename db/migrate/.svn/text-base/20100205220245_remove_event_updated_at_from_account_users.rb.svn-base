class RemoveEventUpdatedAtFromAccountUsers < ActiveRecord::Migration
  def self.up
    remove_column :account_users, :event_updated_at
  end

  def self.down
    add_column :account_users, :event_updated_at, :datetime
  end
end
