class CreateBackpackReminders < ActiveRecord::Migration
  def self.up
    create_table :backpack_reminders do |t|
      t.integer :user_id
      t.integer :calendar_id
      t.integer :calendar_event_id
      t.integer :reminder_id

      t.timestamps
    end
  end

  def self.down
    drop_table :backpack_reminders
  end
end
