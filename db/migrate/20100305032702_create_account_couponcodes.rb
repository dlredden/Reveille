class CreateAccountCouponcodes < ActiveRecord::Migration
  def self.up
    create_table :account_couponcodes do |t|
      t.string :couponcode
      t.integer :account_id

      t.timestamps
    end
  end

  def self.down
    drop_table :account_couponcodes
  end
end
