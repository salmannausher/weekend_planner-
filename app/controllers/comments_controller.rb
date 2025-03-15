class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_plan
  
  def create
    @comment = @plan.comments.build(comment_params)
    @comment.user = current_user
    
    if @comment.save
      if params[:shared_view]
        redirect_to shared_plan_path(@plan.share_token), notice: "Comment was successfully added."
      else
        redirect_to @plan, notice: "Comment was successfully added."
      end
    else
      if params[:shared_view]
        redirect_to shared_plan_path(@plan.share_token), alert: "Failed to add comment: #{@comment.errors.full_messages.join(', ')}"
      else
        redirect_to @plan, alert: "Failed to add comment: #{@comment.errors.full_messages.join(', ')}"
      end
    end
  end

  def destroy
    @comment = @plan.comments.find(params[:id])
    
    # Only allow the plan owner or the comment creator to delete
    if current_user == @plan.user || current_user == @comment.user
      @comment.destroy
      redirect_to @plan, notice: "Comment was successfully removed."
    else
      redirect_to @plan, alert: "You don't have permission to delete this comment."
    end
  end
  
  private
  
  def set_plan
    @plan = Plan.find(params[:plan_id])
  end
  
  def comment_params
    params.require(:comment).permit(:content)
  end
end
