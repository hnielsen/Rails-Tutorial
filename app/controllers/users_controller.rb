class UsersController < ApplicationController
  before_filter :authenticate, :only => [ :index, :edit, :update, :destroy ]
  before_filter :correct_user, :only => [ :edit, :update ]
  before_filter :admin_user, :only => :destroy

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

  # -------------------------------------------------------------------------------------
  private

  def authenticate
    deny_access unless signed_in?
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to root_path unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end
end
