class UsersController < ApplicationController
  before_filter :authenticate, :except => [ :show, :new, :create ]
  before_filter :correct_user, :only => [ :edit, :update ]
  before_filter :admin_user, :only => :destroy
  before_filter :prevent_signup_for_signedin, :only => [ :new, :create ]
  before_filter :prevent_admin_self_delete, :only => :destroy

  def index
    @title = "All users"
    # @users = User.paginate(:page => params[:page], :per_page => 20)
    @users = User.page(params[:page])
  
    respond_to do |wants|
      wants.html # index.html.erb
      wants.xml  { render :xml => @users }
    end
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(:page => params[:page])
    @title = @user.name
  end

  def new
    @user = User.new
    @title = "Sign up"
  end

  def create
    @user = User.new(params[:user])
  
    respond_to do |wants|
      if @user.save
        sign_in @user
        # flash[:notice] = 'User was successfully created.'
        flash[:success] = 'Welcome to the Sample App'
        wants.html { redirect_to @user }
        wants.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        @title = "Sign up"
        wants.html { render :action => "new" }
        wants.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @title = "Edit user"
  end

  def update
    respond_to do |wants|
      if @user.update_attributes(params[:user])
        flash[:success] = 'Profile updated.'
        wants.html { redirect_to(@user) }
        wants.xml  { head :ok }
      else
        @title = "Edit user"
        wants.html { render :action => "edit" }
        wants.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:success] = "User #{params[:id]} deleted"
  
    respond_to do |wants|
      wants.html { redirect_to(users_url) }
      wants.xml  { head :ok }
    end
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(:page => params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(:page => params[:page])
    render 'show_follow'
  end

  # -------------------------------------------------------------------------------------
  private

  def correct_user
    @user = User.find(params[:id])
    redirect_to root_path unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end

  def prevent_signup_for_signedin
    redirect_to(root_path) if current_user
  end

  def prevent_admin_self_delete
    redirect_to users_path if (current_user.admin? && current_user?(@user))
  end
end
