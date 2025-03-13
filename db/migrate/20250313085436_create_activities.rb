class CreateActivities < ActiveRecord::Migration[8.0]
  def change
    create_table :activities do |t|
      t.string :name
      t.text :description
      t.string :location
      t.datetime :start_time
      t.datetime :end_time
      t.references :weekend, null: false, foreign_key: true
      t.string :suggested_by
      t.decimal :cost
      t.boolean :weather_dependent

      t.timestamps
    end
  end
end
