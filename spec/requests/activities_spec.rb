require 'rails_helper'

RSpec.describe "Activities", type: :request do
  describe "GET /create" do
    it "returns http success" do
      get "/activities/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/activities/update"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/activities/destroy"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /vote" do
    it "returns http success" do
      get "/activities/vote"
      expect(response).to have_http_status(:success)
    end
  end

end
