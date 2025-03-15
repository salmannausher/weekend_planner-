class RenameWeekendsToPlans < ActiveRecord::Migration[8.0]
  def change
    rename_table :weekends, :plans
    
    # Update foreign keys in related tables
    rename_column :activities, :weekend_id, :plan_id
    rename_column :comments, :weekend_id, :plan_id
    rename_column :weather_forecasts, :weekend_id, :plan_id
  end
end
