class CommentsController < ApplicationController
  before_action :set_weekend
  
  def create
    @comment = @weekend.comments.build(comment_params)
    
    if @comment.save
      if params[:shared_view]
        redirect_to shared_weekend_path(@weekend.share_token), notice: "Comment was successfully added."
      else
        redirect_to @weekend, notice: "Comment was successfully added."
      end
    else
      if params[:shared_view]
        redirect_to shared_weekend_path(@weekend.share_token), alert: "Failed to add comment: #{@comment.errors.full_messages.join(', ')}"
      else
        redirect_to @weekend, alert: "Failed to add comment: #{@comment.errors.full_messages.join(', ')}"
      end
    end
  end

  def destroy
    @comment = @weekend.comments.find(params[:id])
    
    # Only allow the weekend owner or the comment creator to delete
    if current_user == @weekend.user || current_user.email == @comment.commenter_email
      @comment.destroy
      redirect_to @weekend, notice: "Comment was successfully removed."
    else
      redirect_to @weekend, alert: "You don't have permission to delete this comment."
    end
  end
  
  private
  
  def set_weekend
    @weekend = Weekend.find(params[:weekend_id])
  end
  
  def comment_params
    params.require(:comment).permit(:commenter_name, :commenter_email, :content)
  end
end
