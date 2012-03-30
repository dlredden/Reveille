class RemoveUserIdFromPayment < ActiveRecord::Migration
  def self.up
    remove_column :payments, :user_id
  end

  def self.down
    add_column :payments, :user_id, :integer
  end
end
