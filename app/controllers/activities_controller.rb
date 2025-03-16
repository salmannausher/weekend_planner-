class ActivitiesController < ApplicationController
  before_action :authenticate_user!, except: [:create, :vote, :create_from_shared]
  before_action :set_plan
  before_action :set_activity, only: [:edit, :update, :destroy, :vote]
  before_action :ensure_owner, only: [:edit, :update, :destroy]
  
  def create
    # This method is for authenticated users
    unless user_signed_in?
      redirect_to root_path, alert: "You don't have permission to perform this action."
      return
    end
    
    @activity = @plan.activities.build(activity_params)
    @activity.suggested_by = current_user.name
    
    respond_to do |format|
      if @activity.save
        format.html { redirect_to @plan, notice: "Activity was successfully added." }
        format.turbo_stream { render :create }
      else
        format.html { redirect_to @plan, alert: "Failed to add activity: #{@activity.errors.full_messages.join(', ')}" }
        format.turbo_stream { 
          render turbo_stream: turbo_stream.replace(
            "activity-form", 
            partial: "activities/form", 
            locals: { plan: @plan, activity: @activity }
          )
        }
      end
    end
  end
  
  # New method for creating activities from shared plans
  def create_from_shared
    # Check if the plan has a share token
    unless @plan.share_token.present?
      redirect_to root_path, alert: "You don't have permission to perform this action."
      return
    end
    
    @activity = @plan.activities.build(activity_params)
    @activity.suggested_by = "Guest"
    
    respond_to do |format|
      if @activity.save
        format.html { redirect_to shared_plan_path(@plan.share_token), notice: "Activity was successfully added." }
        format.turbo_stream { render :create }
      else
        format.html { redirect_to shared_plan_path(@plan.share_token), alert: "Failed to add activity: #{@activity.errors.full_messages.join(', ')}" }
        format.turbo_stream { 
          render turbo_stream: turbo_stream.replace(
            "activity-form", 
            partial: "activities/form", 
            locals: { plan: @plan, activity: @activity }
          )
        }
      end
    end
  end
  
  def edit
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def update
    respond_to do |format|
      if @activity.update(activity_params)
        format.html { redirect_to @plan, notice: "Activity was successfully updated." }
        format.turbo_stream
      else
        format.html { redirect_to @plan, alert: "Failed to update activity: #{@activity.errors.full_messages.join(', ')}" }
        format.turbo_stream { render turbo_stream: turbo_stream.replace("activity-form", partial: "activities/form", locals: { plan: @plan, activity: @activity }) }
      end
    end
  end

  def destroy
    @activity.destroy
    
    respond_to do |format|
      format.html { redirect_to @plan, notice: "Activity was successfully removed." }
      format.turbo_stream
    end
  end

  def vote
    # Allow voting without login for shared plans
    unless @plan.share_token.present? || user_signed_in?
      redirect_to @plan, alert: "This plan is not shared yet."
      return
    end
    
    if user_signed_in?
      @activity.toggle_vote(current_user)
      redirect_to @plan, notice: "Your vote has been recorded."
    else
      redirect_to shared_plan_path(@plan.share_token), alert: "You need to be signed in to vote."
    end
  end
  
  private
  
  def set_plan
    @plan = Plan.find(params[:plan_id])
  end
  
  def set_activity
    @activity = @plan.activities.find(params[:id])
  end
  
  def ensure_owner
    unless @plan.user == current_user
      redirect_to @plan, alert: "You don't have permission to perform this action."
    end
  end
  
  def activity_params
    params.require(:activity).permit(:name, :description, :location)
  end
end
