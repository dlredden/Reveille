class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :payments do |t|
      t.integer :user_id
      t.string :name
      t.string :type
      t.binary :number
      t.binary :number_key
      t.binary :number_iv
      t.binary :scode
      t.binary :scode_key
      t.binary :scode_iv
      t.string :exp_date

      t.timestamps
    end
  end

  def self.down
    drop_table :payments
  end
end
