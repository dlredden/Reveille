class AddNextBillDateToAccount < ActiveRecord::Migration
  def self.up
    add_column :accounts, :next_bill_date, :date
  end

  def self.down
    remove_column :accounts, :next_bill_date
  end
end
