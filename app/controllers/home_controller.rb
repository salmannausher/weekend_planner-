class HomeController < ApplicationController
  def index
    redirect_to weekends_path if user_signed_in?
    # Otherwise, show the landing page
  end
end
