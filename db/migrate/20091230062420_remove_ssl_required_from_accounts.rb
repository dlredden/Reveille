class RemoveSslRequiredFromAccounts < ActiveRecord::Migration
  def self.up
    remove_column :accounts, :requires_ssl
  end

  def self.down
    add_column :accounts, :requires_ssl, :boolean
  end
end
