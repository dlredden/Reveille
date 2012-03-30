class AddEventUpdatedAtToBackpackReminders < ActiveRecord::Migration
  def self.up
    add_column :backpack_reminders, :event_updated_at, :datetime
  end

  def self.down
    remove_column :backpack_reminders, :event_updated_at
  end
end
