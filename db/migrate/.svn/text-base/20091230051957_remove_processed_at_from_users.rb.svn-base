class RemoveProcessedAtFromUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :processed_at
  end

  def self.down
    add_column :users, :processed_at, :datetime
  end
end
