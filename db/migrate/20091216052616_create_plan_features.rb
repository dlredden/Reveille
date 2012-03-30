class CreatePlanFeatures < ActiveRecord::Migration
  def self.up
    create_table :plan_features do |t|
      t.integer :plan_id
      t.string :name
      t.integer :value

      t.timestamps
    end
  end

  def self.down
    drop_table :plan_features
  end
end
