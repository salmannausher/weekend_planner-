class UpdateWeatherForecastsColumns < ActiveRecord::Migration[8.0]
  def change
    # Rename existing columns
    rename_column :weather_forecasts, :conditions, :condition
    
    # Add new columns
    add_column :weather_forecasts, :temperature_high, :float
    add_column :weather_forecasts, :temperature_low, :float
    add_column :weather_forecasts, :humidity, :float
    add_column :weather_forecasts, :wind_speed, :float
    
    # Copy data from temperature to temperature_high and temperature_low
    WeatherForecast.find_each do |forecast|
      forecast.update_columns(
        temperature_high: forecast.temperature,
        temperature_low: forecast.temperature - rand(5..15)
      )
    end
  end
end
