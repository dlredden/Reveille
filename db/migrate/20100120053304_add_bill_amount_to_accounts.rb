class AddBillAmountToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :bill_amount, :decimal, :precision => 10, :scale => 2
  end

  def self.down
    remove_column :accounts, :bill_amount
  end
end
