class UsersController < ApplicationController
  def new
    @user = User.new
    @title = "Sign up"
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      @title = "Sign up"
      logger.error "Failed to create user: " + @user.to_s
      
      # Clear the password
      @user.password = ""
      @user.password_confirmation = ""
      render :new
    end
  end
  
  def show
    @user = User.find(params[:id])
    @title = @user.name
  end

end
