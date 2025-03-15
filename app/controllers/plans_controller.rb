class PlansController < ApplicationController
  before_action :authenticate_user!, except: [:shared]
  before_action :set_plan, only: [:show, :edit, :update, :destroy, :share, :finalize]
  before_action :ensure_owner, only: [:edit, :update, :destroy, :finalize]
  
  def index
    @plans = current_user.plans.order(created_at: :desc)
    @temperature = fetch_temperature
  end

  def show
    @activity = Activity.new
    @suggested_activities = generate_suggested_activities
    
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def new
    @plan = Plan.new
    @temperature = fetch_temperature
    
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def create
    @plan = current_user.plans.build(plan_params)
    
    if @plan.save
      redirect_to @plan, notice: "Plan was successfully created."
    else
      @temperature = fetch_temperature
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @temperature = fetch_temperature
    
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def update
    if @plan.update(plan_params)
      redirect_to @plan, notice: "Plan was successfully updated."
    else
      @temperature = fetch_temperature
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @plan.destroy
    redirect_to plans_path, notice: "Plan was successfully deleted."
  end

  def share
    # Generate a shareable link if not already present
    @plan.update(status: 'shared') unless @plan.shared?
    redirect_to @plan, notice: "Plan has been shared. Copy the link to share with others."
  end
  
  def finalize
    @plan.update(status: 'finalized')
    redirect_to @plan, notice: "Plan has been finalized."
  end
  
  def shared
    @plan = Plan.find_by!(share_token: params[:token])
    @suggested_activities = generate_suggested_activities
    render :show
  end
  
  private
  
  def set_plan
    @plan = Plan.find(params[:id])
  end
  
  def ensure_owner
    unless @plan.user == current_user
      redirect_to plans_path, alert: "You don't have permission to perform this action."
    end
  end
  
  def plan_params
    params.require(:plan).permit(:title, :start_date, :end_date, :location, :description)
  end
  
  def generate_suggested_activities
    location = @plan.location.downcase
    
    # Base activities that work for any location
    activities = [
      {
        name: "Local Farmers Market",
        description: "Visit the local farmers market to sample fresh produce and artisanal goods."
      },
      {
        name: "Scenic Photography Walk",
        description: "Bring your camera and capture the beauty of #{@plan.location}."
      },
      {
        name: "Picnic in the Park",
        description: "Pack a basket with your favorite foods and enjoy a relaxing picnic outdoors."
      },
      {
        name: "Local Museum Visit",
        description: "Explore the history and culture of #{@plan.location} at a local museum."
      }
    ]
    
    # Add location-specific activities
    if location.include?("beach") || location.include?("miami") || location.include?("coast")
      activities.concat([
        {
          name: "Beach Day",
          description: "Spend a relaxing day at the beach with swimming and sunbathing."
        },
        {
          name: "Sunset Beach Walk",
          description: "Take a romantic walk along the shore as the sun sets."
        },
        {
          name: "Water Sports Adventure",
          description: "Try paddleboarding, kayaking, or jet skiing for some aquatic fun."
        }
      ])
    elsif location.include?("mountain") || location.include?("denver") || location.include?("aspen")
      activities.concat([
        {
          name: "Hiking Trail",
          description: "Explore a scenic hiking trail with beautiful mountain views."
        },
        {
          name: "Mountain Biking",
          description: "Rent bikes and hit the mountain trails for an adrenaline rush."
        },
        {
          name: "Scenic Overlook Visit",
          description: "Drive to a scenic overlook for breathtaking panoramic views."
        }
      ])
    elsif location.include?("new york") || location.include?("nyc") || location.include?("chicago") || location.include?("los angeles")
      activities.concat([
        {
          name: "City Food Tour",
          description: "Sample the diverse culinary offerings at local restaurants and food trucks."
        },
        {
          name: "Iconic Landmarks Tour",
          description: "Visit the must-see landmarks and attractions in the city."
        },
        {
          name: "Local Theater Show",
          description: "Catch a performance at a local theater or comedy club."
        }
      ])
    end
    
    # Shuffle and return a subset of activities
    activities.shuffle.take(6)
  end

  def fetch_temperature
    # Reuse the same method from HomeController
    HomeController.new.send(:fetch_temperature)
  end
end
