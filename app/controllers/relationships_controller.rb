class RelationshipsController < ApplicationController
  before_filter :authenticate

  def create
    @user = User.find(params[:relationship][:followed_id])
    current_user.follow! @user
    respond_to do |wants|
      wants.html {redirect_to @user}
      wants.js
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow! @user
    respond_to do |wants|
      wants.html  {redirect_to @user}
      wants.js
    end
  end
end
