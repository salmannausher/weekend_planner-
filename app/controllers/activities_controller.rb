class ActivitiesController < ApplicationController
  before_action :authenticate_user!, except: [:vote]
  before_action :set_weekend
  before_action :set_activity, only: [:update, :destroy, :vote]
  before_action :ensure_owner, only: [:update, :destroy]
  
  def create
    @activity = @weekend.activities.build(activity_params)
    @activity.suggested_by = current_user.email if user_signed_in?
    
    if @activity.save
      redirect_to @weekend, notice: "Activity was successfully added."
    else
      redirect_to @weekend, alert: "Failed to add activity: #{@activity.errors.full_messages.join(', ')}"
    end
  end

  def update
    if @activity.update(activity_params)
      redirect_to @weekend, notice: "Activity was successfully updated."
    else
      redirect_to @weekend, alert: "Failed to update activity: #{@activity.errors.full_messages.join(', ')}"
    end
  end

  def destroy
    @activity.destroy
    redirect_to @weekend, notice: "Activity was successfully removed."
  end

  def vote
    # Allow voting without login for shared weekends
    unless @weekend.shared? || @weekend.finalized? || user_signed_in?
      redirect_to @weekend, alert: "This weekend plan is not shared yet."
      return
    end
    
    @vote = @activity.votes.find_or_initialize_by(voter_email: vote_params[:voter_email])
    @vote.assign_attributes(vote_params)
    
    if @vote.save
      redirect_to shared_weekend_path(@weekend.share_token), notice: "Your vote has been recorded."
    else
      redirect_to shared_weekend_path(@weekend.share_token), alert: "Failed to record vote: #{@vote.errors.full_messages.join(', ')}"
    end
  end
  
  private
  
  def set_weekend
    @weekend = Weekend.find(params[:weekend_id])
  end
  
  def set_activity
    @activity = @weekend.activities.find(params[:id])
  end
  
  def ensure_owner
    unless @weekend.user == current_user
      redirect_to @weekend, alert: "You don't have permission to perform this action."
    end
  end
  
  def activity_params
    params.require(:activity).permit(:name, :description, :location, :start_time, :end_time, :cost, :weather_dependent)
  end
  
  def vote_params
    params.require(:vote).permit(:voter_name, :voter_email, :vote_type)
  end
end
