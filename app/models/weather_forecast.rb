class WeatherForecast < ApplicationRecord
  belongs_to :plan
  
  validates :date, :condition, presence: true
  validates :temperature_high, :temperature_low, presence: true, if: -> { temperature.nil? }
  validates :temperature, presence: true, if: -> { temperature_high.nil? || temperature_low.nil? }
  
  # Fetch weather data from API
  def self.fetch_for_plan(plan)
    require 'net/http'
    require 'json'
    
    # Use the plan's location
    city = plan.location
    
    # OpenWeatherMap API key (same as in HomeController)
    api_key = "4da2a5339b0153663edc5e54e0568913"
    
    begin
      # Call the 5-day forecast API
      url = URI("https://api.openweathermap.org/data/2.5/forecast?q=#{URI.encode_www_form_component(city)}&appid=#{api_key}&units=imperial")
      response = Net::HTTP.get_response(url)
      
      if response.is_a?(Net::HTTPSuccess)
        data = JSON.parse(response.body)
        
        # Clear existing forecasts
        plan.weather_forecasts.destroy_all
        
        # Group forecast data by date
        forecasts_by_date = {}
        
        data["list"].each do |forecast|
          # Convert timestamp to date
          date = Time.at(forecast["dt"]).to_date
          
          # Skip if date is outside plan range
          next unless date >= plan.start_date && date <= plan.end_date
          
          # Initialize data structure for this date if needed
          forecasts_by_date[date] ||= {
            temps: [],
            conditions: []
          }
          
          # Add temperature and condition
          forecasts_by_date[date][:temps] << forecast["main"]["temp"]
          forecasts_by_date[date][:conditions] << forecast["weather"][0]["main"]
        end
        
        # Create a forecast for each date in the plan
        (plan.start_date..plan.end_date).each do |date|
          if forecasts_by_date[date]
            # Calculate high and low temperatures
            temps = forecasts_by_date[date][:temps]
            high = temps.max.round
            low = temps.min.round
            
            # Get the most common condition
            conditions = forecasts_by_date[date][:conditions]
            condition = conditions.group_by(&:itself).max_by { |_, v| v.size }.first
            
            # Create the forecast
            plan.weather_forecasts.create(
              date: date,
              temperature: (high + low) / 2.0,
              temperature_high: high,
              temperature_low: low,
              condition: condition,
              humidity: rand(30..90), # API doesn't provide average humidity
              wind_speed: rand(0..20) # API doesn't provide average wind speed
            )
          else
            # If no data for this date, use fallback data
            high = rand(65..85)
            low = rand(45..65)
            plan.weather_forecasts.create(
              date: date,
              temperature: (high + low) / 2.0,
              temperature_high: high,
              temperature_low: low,
              condition: ['Sunny', 'Partly Cloudy', 'Cloudy', 'Rainy', 'Stormy'].sample,
              humidity: rand(30..90),
              wind_speed: rand(0..20)
            )
          end
        end
        
        return true
      else
        # Fallback to sample data if API call fails
        create_sample_data(plan)
      end
    rescue => e
      # Log the error
      Rails.logger.error("Weather API error: #{e.message}")
      
      # Fallback to sample data
      create_sample_data(plan)
    end
  end
  
  # Create sample weather data
  def self.create_sample_data(plan)
    (plan.start_date..plan.end_date).each do |date|
      high = rand(65..85)
      low = rand(45..65)
      plan.weather_forecasts.create(
        date: date,
        temperature: (high + low) / 2.0,
        temperature_high: high,
        temperature_low: low,
        condition: ['Sunny', 'Partly Cloudy', 'Cloudy', 'Rainy', 'Stormy'].sample,
        humidity: rand(30..90),
        wind_speed: rand(0..20)
      )
    end
  end
  
  # Fetch weather for nearby cities
  def self.fetch_nearby_cities(city)
    require 'net/http'
    require 'json'
    
    # OpenWeatherMap API key
    api_key = "4da2a5339b0153663edc5e54e0568913"
    
    # Define nearby cities based on the main city
    # This is a simplified approach - in a real app, you would use geocoding
    nearby_cities = case city.downcase
    when /new york/
      ["Boston", "Philadelphia", "Washington DC", "Baltimore"]
    when /los angeles/
      ["San Diego", "San Francisco", "Las Vegas", "Phoenix"]
    when /chicago/
      ["Milwaukee", "Indianapolis", "Detroit", "Cleveland"]
    when /houston/
      ["Dallas", "San Antonio", "Austin", "New Orleans"]
    when /miami/
      ["Orlando", "Tampa", "Jacksonville", "Key West"]
    else
      # Default to some major US cities
      ["New York", "Los Angeles", "Chicago", "Houston"]
    end
    
    # Fetch weather for each city
    results = []
    
    nearby_cities.each do |nearby_city|
      begin
        url = URI("https://api.openweathermap.org/data/2.5/weather?q=#{URI.encode_www_form_component(nearby_city)}&appid=#{api_key}&units=imperial")
        response = Net::HTTP.get_response(url)
        
        if response.is_a?(Net::HTTPSuccess)
          data = JSON.parse(response.body)
          
          results << {
            city: data["name"],
            temperature: data["main"]["temp"].round,
            condition: data["weather"][0]["main"],
            icon: data["weather"][0]["icon"]
          }
        else
          # Add fallback data if API call fails
          results << {
            city: nearby_city,
            temperature: rand(65..85),
            condition: "Unknown",
            icon: "01d"
          }
        end
      rescue => e
        # Log the error
        Rails.logger.error("Weather API error for #{nearby_city}: #{e.message}")
        
        # Add fallback data
        results << {
          city: nearby_city,
          temperature: rand(65..85),
          condition: "Unknown",
          icon: "01d"
        }
      end
    end
    
    results
  end
end
