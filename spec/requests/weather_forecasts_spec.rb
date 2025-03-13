require 'rails_helper'

RSpec.describe "WeatherForecasts", type: :request do
  describe "GET /fetch" do
    it "returns http success" do
      get "/weather_forecasts/fetch"
      expect(response).to have_http_status(:success)
    end
  end

end
