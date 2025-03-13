class UsersController < ApplicationController
  def new
    @user = User.new
    redirect_to weekends_path if logged_in?
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      session[:user_id] = @user.id
      redirect_to weekends_path, notice: "Account created successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
