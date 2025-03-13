class WeatherForecast < ApplicationRecord
  belongs_to :weekend
  
  validates :date, :temperature, :conditions, presence: true
  validates :date, uniqueness: { scope: :weekend_id }
  
  def favorable?
    # Simple logic to determine if weather is favorable
    # This could be expanded based on activity types
    !conditions.downcase.include?('rain') && 
    !conditions.downcase.include?('snow') && 
    !conditions.downcase.include?('storm')
  end
end
