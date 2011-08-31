class UsersController < ApplicationController

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
        flash[:notice] = 'User was successfully created.'
        wants.html { redirect_to(@user) }
        wants.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        @title = "Sign up"
        wants.html { render :action => "new" }
        wants.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
end
