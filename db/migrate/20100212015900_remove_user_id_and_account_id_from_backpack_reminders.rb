class RemoveUserIdAndAccountIdFromBackpackReminders < ActiveRecord::Migration
  def self.up
    remove_column :backpack_reminders, :user_id
    remove_column :backpack_reminders, :account_id
  end

  def self.down
    add_column :backpack_reminders, :account_id, :integer
    add_column :backpack_reminders, :user_id, :integer
  end
end
