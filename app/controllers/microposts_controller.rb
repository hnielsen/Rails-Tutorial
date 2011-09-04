class MicropostsController < ApplicationController
  before_filter :authenticate
  before_filter :authorized_user, :only => :destroy

  def create
    @micropost = current_user.microposts.build(params[:micropost])
  
    respond_to do |wants|
      if @micropost.save
        flash[:success] = 'Micropost created.'
        wants.html { redirect_to root_path }
        wants.xml  { render :xml => @micropost, :status => :created, :location => @micropost }
      else
        @feed_items = []
        wants.html { render 'pages/home' }
        wants.xml  { render :xml => @micropost.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @micropost.destroy
  
    respond_to do |wants|
      wants.html { redirect_to root_path }
      wants.xml  { head :ok }
    end
  end
  
  # -------------------------------------------------------------------------------------
  private

  def authorized_user
    @micropost = current_user.microposts.find(params[:id])
  rescue
    redirect_to root_path 
  end
end
