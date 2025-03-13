class CreateWeatherForecasts < ActiveRecord::Migration[8.0]
  def change
    create_table :weather_forecasts do |t|
      t.references :weekend, null: false, foreign_key: true
      t.date :date
      t.float :temperature
      t.string :conditions

      t.timestamps
    end
  end
end
