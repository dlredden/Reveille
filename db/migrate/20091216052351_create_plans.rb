class CreatePlans < ActiveRecord::Migration
  def self.up
    create_table :plans do |t|
      t.string :name
      t.decimal :price
      t.boolean :active

      t.timestamps
    end
  end

  def self.down
    drop_table :plans
  end
end
