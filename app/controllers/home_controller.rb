class HomeController < ApplicationController
  require 'net/http'
  require 'json'

  def index
    if user_signed_in?
      redirect_to plans_path 
    else
      # Fetch temperature data for the home page
      @temperature = fetch_temperature
    end
  end
  
  private
  
  def fetch_temperature
    # Try to fetch real weather data from OpenWeatherMap API
    begin
      # Default to a major city if we can't get user's location
      city = "New York"
      
      # OpenWeatherMap API endpoint (using their free tier)
      # In a production app, you would store this API key in credentials
      api_key = "4da2a5339b0153663edc5e54e0568913" # This is a free API key for demo purposes
      url = URI("https://api.openweathermap.org/data/2.5/weather?q=#{city}&appid=#{api_key}&units=imperial")
      
      response = Net::HTTP.get_response(url)
      
      if response.is_a?(Net::HTTPSuccess)
        data = JSON.parse(response.body)
        
        # Extract relevant data from the API response
        {
          location: data["name"],
          current: data["main"]["temp"].round,
          condition: data["weather"][0]["main"],
          high: data["main"]["temp_max"].round,
          low: data["main"]["temp_min"].round,
          unit: "F"
        }
      else
        # Fallback to mock data if API call fails
        fallback_weather_data
      end
    rescue => e
      # Log the error in a real app
      Rails.logger.error("Weather API error: #{e.message}")
      
      # Return fallback data
      fallback_weather_data
    end
  end
  
  def fallback_weather_data
    {
      location: "New York",
      current: 72,
      condition: "Sunny",
      high: 78,
      low: 65,
      unit: "F"
    }
  end
end
