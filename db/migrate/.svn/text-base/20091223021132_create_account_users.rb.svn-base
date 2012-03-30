class CreateAccountUsers < ActiveRecord::Migration
  def self.up
    create_table :account_users do |t|
      t.integer :user_id
      t.integer :account_id
      t.integer :role_id

      t.timestamps
    end
  end

  def self.down
    drop_table :account_users
  end
end
