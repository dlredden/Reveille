class AddSslRequiredToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :ssl_required, :boolean
  end

  def self.down
    remove_column :accounts, :ssl_required
  end
end
