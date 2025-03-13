require 'rails_helper'

RSpec.describe "GoogleCalendars", type: :request do
  describe "GET /connect" do
    it "returns http success" do
      get "/google_calendar/connect"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /callback" do
    it "returns http success" do
      get "/google_calendar/callback"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /events" do
    it "returns http success" do
      get "/google_calendar/events"
      expect(response).to have_http_status(:success)
    end
  end

end
