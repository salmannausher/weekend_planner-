class WeatherForecastsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_plan
  
  def fetch
    # This would typically call a weather API service
    # For now, we'll create some sample data
    
    # Clear existing forecasts
    @plan.weather_forecasts.destroy_all
    
    # Create sample forecasts for each day of the plan
    WeatherForecast.fetch_for_plan(@plan)
    
    redirect_to @plan, notice: "Weather forecast has been updated."
  end
  
  private
  
  def set_plan
    @plan = Plan.find(params[:plan_id])
  end
end
