class UsersController < ApplicationController
  before_filter :authenticate, :only => [:index, :edit, :update, :destroy]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user, :only => :destroy
  
  def new
    if signed_in?
      flash[:notice] = "You already have an account."
      redirect_to user_path(current_user)
    end
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
  
  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])
  end
  
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(:page => params[:page])
    @title = @user.name
  end
  
  def edit
    @user = User.find(params[:id])
    @title = "Edit user"
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end
  
  def destroy
    user = User.find(params[:id])
    if current_user?(user)
      flash[:success] = "You cannot delete yourself."
    else
      users_name = user.name
      user.destroy
      flash[:success] = "User '#{users_name}' deleted."
    end
    redirect_to users_path
  end
  
  ###############################################
  # Private Methods
  ###############################################
  private
  
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end
  
  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end

end
