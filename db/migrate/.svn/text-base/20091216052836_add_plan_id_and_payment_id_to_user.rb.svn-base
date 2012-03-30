class AddPlanIdAndPaymentIdToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :plan_id, :integer
    add_column :users, :payment_id, :integer
  end

  def self.down
    remove_column :users, :plan_id
    remove_column :users, :payment_id
  end
end
