class WeatherForecast < ApplicationRecord
  belongs_to :plan
  
  validates :date, :temperature_high, :temperature_low, :condition, presence: true
  
  # Fetch weather data from API
  def self.fetch_for_plan(plan)
    # This would normally call a weather API
    # For now, we'll create sample data
    (plan.start_date..plan.end_date).each do |date|
      plan.weather_forecasts.create(
        date: date,
        temperature_high: rand(65..85),
        temperature_low: rand(45..65),
        condition: ['Sunny', 'Partly Cloudy', 'Cloudy', 'Rainy', 'Stormy'].sample,
        humidity: rand(30..90),
        wind_speed: rand(0..20)
      )
    end
  end
end
