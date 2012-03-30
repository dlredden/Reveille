class AddAccountUserIdToBackpackReminders < ActiveRecord::Migration
  def self.up
    add_column :backpack_reminders, :account_user_id, :integer
  end

  def self.down
    remove_column :backpack_reminders, :account_user_id
  end
end
