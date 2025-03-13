class GoogleCalendarController < ApplicationController
  before_action :authenticate_user!
  
  def connect
    # In a real app, this would redirect to Google OAuth
    redirect_to "https://accounts.google.com/o/oauth2/auth?client_id=YOUR_CLIENT_ID&redirect_uri=#{callback_url}&scope=https://www.googleapis.com/auth/calendar&response_type=code"
  end

  def callback
    # In a real app, this would handle the OAuth callback
    # For now, we'll simulate a successful connection
    
    # Update user with tokens (in a real app, these would come from Google)
    current_user.update(
      google_token: "sample_token_#{SecureRandom.hex(10)}",
      google_refresh_token: "sample_refresh_token_#{SecureRandom.hex(10)}"
    )
    
    redirect_to weekends_path, notice: "Successfully connected to Google Calendar!"
  end

  def events
    # In a real app, this would fetch events from Google Calendar API
    # For now, we'll return sample data
    
    # Check if user has connected their Google account
    unless current_user.google_token.present?
      redirect_to connect_calendar_path, alert: "Please connect your Google Calendar first."
      return
    end
    
    # Sample data - in a real app, this would come from the Google Calendar API
    @events = [
      { title: "Work", start: Date.today, end: Date.today },
      { title: "Gym", start: Date.today + 1.day, end: Date.today + 1.day },
      { title: "Family Dinner", start: Date.today + 2.days, end: Date.today + 2.days }
    ]
    
    # Find free weekends (weekends with no events)
    @free_weekends = []
    
    # Look ahead 3 months
    start_date = Date.today
    end_date = Date.today + 3.months
    
    # Find all weekends in the next 3 months
    (start_date..end_date).select { |d| d.saturday? }.each do |saturday|
      sunday = saturday + 1.day
      
      # Check if there are any events on this weekend
      weekend_events = @events.select do |event|
        (event[:start] == saturday || event[:start] == sunday) ||
        (event[:end] == saturday || event[:end] == sunday)
      end
      
      if weekend_events.empty?
        @free_weekends << { start: saturday, end: sunday }
      end
    end
    
    respond_to do |format|
      format.html
      format.json { render json: { events: @events, free_weekends: @free_weekends } }
    end
  end
  
  private
  
  def callback_url
    "#{request.base_url}/auth/google_oauth2/callback"
  end
end
