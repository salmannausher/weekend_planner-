class WeatherService
  def self.current_temperature
    # This is a mock implementation
    # In a real application, you would call an external API
    {
      location: "New York, NY",
      current: 72,
      high: 78,
      low: 65,
      condition: "Partly Cloudy",
      unit: "F"
    }
  end
end 