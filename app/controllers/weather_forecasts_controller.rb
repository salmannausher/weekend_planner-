class WeatherForecastsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_weekend
  
  def fetch
    # This would typically call a weather API service
    # For now, we'll create some sample data
    
    # Clear existing forecasts
    @weekend.weather_forecasts.destroy_all
    
    # Create sample forecasts for each day of the weekend
    start_date = @weekend.start_date
    end_date = @weekend.end_date
    
    (start_date..end_date).each do |date|
      # In a real app, this would call a weather API
      @weekend.weather_forecasts.create(
        date: date,
        temperature: rand(15..30),  # Random temperature between 15-30°C
        conditions: ['Sunny', 'Partly Cloudy', 'Cloudy', 'Light Rain', 'Thunderstorm'].sample
      )
    end
    
    redirect_to @weekend, notice: "Weather forecast has been updated."
  end
  
  private
  
  def set_weekend
    @weekend = Weekend.find(params[:weekend_id])
  end
end
