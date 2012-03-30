class CreateBackpackAccounts < ActiveRecord::Migration
  def self.up
    create_table :backpack_accounts do |t|
      t.integer :user_id
      t.string :username
      t.string :api_token
      t.boolean :requires_ssl

      t.timestamps
    end
  end

  def self.down
    drop_table :backpack_accounts
  end
end
