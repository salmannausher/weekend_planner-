class WeatherForecastsController < ApplicationController
  before_action :authenticate_user!, except: [:nearby]
  before_action :set_plan, except: [:nearby]
  
  def fetch
    # Use the updated method to fetch real weather data
    WeatherForecast.fetch_for_plan(@plan)
    
    # Fetch nearby cities weather data
    @nearby_cities = WeatherForecast.fetch_nearby_cities(@plan.location)
    
    respond_to do |format|
      format.html { redirect_to @plan, notice: "Weather forecast has been updated." }
      format.turbo_stream
    end
  end
  
  def nearby
    # Get the city from params or default to New York
    city = params[:city] || "New York"
    
    # Fetch nearby cities weather data
    @nearby_cities = WeatherForecast.fetch_nearby_cities(city)
    
    respond_to do |format|
      format.html
      format.json { render json: @nearby_cities }
      format.turbo_stream
    end
  end
  
  private
  
  def set_plan
    @plan = Plan.find(params[:plan_id])
  end
end
