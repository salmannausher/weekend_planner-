require 'rails_helper'

RSpec.describe "Weekends", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/weekends/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/weekends/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/weekends/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/weekends/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/weekends/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/weekends/update"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/weekends/destroy"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /share" do
    it "returns http success" do
      get "/weekends/share"
      expect(response).to have_http_status(:success)
    end
  end

end
