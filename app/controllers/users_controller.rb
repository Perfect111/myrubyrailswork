class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:follow, :show, :edit, :update]
  before_filter :current_user, :only => [:follow, :remove, :followers, :following]
  before_filter :user_from_login, :only => [:follow, :remove, :followers, :following, :ajax_followers, :ajax_following]
  before_filter :tags
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Account registered!"
      redirect_back_or_default root_url
    else
      render :action => :new
    end
  end
  
  def follow
    @user.add_follower(@current_user)
    @user.save
    flash[:notice] = "You are now following " + @user.login
    redirect_back_or_default statuses_url
  end
  
  def remove
    @user.remove_follower(@current_user)
    @user.save
    flash[:notice] = "You are no longer following " + @user.login
    redirect_back_or_default statuses_url
  end
  
  def followers
    @followers = @user.followers
  end
  
  def following
    @following = @user.followings
  end
  
  def ajax_followers
    #@followers = @user.followers
    @followers = @user.followers_filtered
    render :layout => false
  end
  
  def ajax_following
    #@following = @user.followings
    @following = @user.followings_filtered
    render :layout => false
  end
  
  def show
    @user = @current_user
  end
 
  def edit
    @user = @current_user
  end
  
  def update
    @user = @current_user # makes our views "cleaner" and more consistent
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to root_url
    else
      render :action => :edit
    end
  end
  

  
end