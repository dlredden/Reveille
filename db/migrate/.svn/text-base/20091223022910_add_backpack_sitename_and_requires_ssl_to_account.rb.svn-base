class AddBackpackSitenameAndRequiresSslToAccount < ActiveRecord::Migration
  def self.up
    add_column :accounts, :backpack_sitename, :string
    add_column :accounts, :requires_ssl, :boolean
  end

  def self.down
    remove_column :accounts, :requires_ssl
    remove_column :accounts, :backpack_sitename
  end
end
