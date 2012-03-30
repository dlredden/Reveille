class RemoveSslRequiredFromPlans < ActiveRecord::Migration
  def self.up
    remove_column :plans, :ssl_required
  end

  def self.down
    add_column :plans, :ssl_required, :boolean
  end
end
