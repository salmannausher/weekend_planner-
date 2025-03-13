class WeekendsController < ApplicationController
  before_action :authenticate_user!, except: [:shared]
  before_action :set_weekend, only: [:show, :edit, :update, :destroy, :share, :finalize]
  before_action :ensure_owner, only: [:edit, :update, :destroy, :finalize]
  
  def index
    @weekends = current_user.weekends.order(created_at: :desc)
  end

  def show
  end

  def new
    @weekend = Weekend.new
  end

  def create
    @weekend = current_user.weekends.build(weekend_params)
    
    if @weekend.save
      redirect_to @weekend, notice: "Weekend plan was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @weekend.update(weekend_params)
      redirect_to @weekend, notice: "Weekend plan was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @weekend.destroy
    redirect_to weekends_path, notice: "Weekend plan was successfully deleted."
  end

  def share
    # Generate a shareable link if not already present
    @weekend.update(status: 'shared') unless @weekend.shared?
    @share_url = shared_weekend_url(@weekend.share_token)
  end
  
  def finalize
    @weekend.update(status: 'finalized')
    redirect_to @weekend, notice: "Weekend plan has been finalized."
  end
  
  def shared
    @weekend = Weekend.find_by!(share_token: params[:token])
    render :show
  end
  
  private
  
  def set_weekend
    @weekend = Weekend.find(params[:id])
  end
  
  def ensure_owner
    unless @weekend.user == current_user
      redirect_to weekends_path, alert: "You don't have permission to perform this action."
    end
  end
  
  def weekend_params
    params.require(:weekend).permit(:title, :start_date, :end_date, :location, :description)
  end
end
