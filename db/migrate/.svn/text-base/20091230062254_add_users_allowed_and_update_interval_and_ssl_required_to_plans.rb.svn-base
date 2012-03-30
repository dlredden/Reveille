class AddUsersAllowedAndUpdateIntervalAndSslRequiredToPlans < ActiveRecord::Migration
  def self.up
    add_column :plans, :users_allowed, :integer
    add_column :plans, :update_interval, :integer
    add_column :plans, :ssl_required, :boolean
  end

  def self.down
    remove_column :plans, :ssl_required
    remove_column :plans, :update_interval
    remove_column :plans, :users_allowed
  end
end
