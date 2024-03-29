# == Schema Information
#
# Table name: users
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  password_digest :string(255)
#  admin           :boolean         default(FALSE)
#

require 'spec_helper'

describe User do
  before(:each) do
    @attr = { 
      :name => "Test User", 
      :email => "test@user.com", 
      :password => "secret",
      :password_confirmation => "secret"
    }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end

  it "should require a name" do
    no_name_user = User.new(@attr.merge(:name => ""))
    no_name_user.should_not be_valid
  end

  it "should require an email" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end

  it "should reject names that are too long" do
    long_name = "a" * 51
    long_name_user = User.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end

  it "should accept valid email addresses" do
    emails = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp] 
    emails.each do |email|
      valid_email_user = User.new(@attr.merge(:email => email))
      valid_email_user.should be_valid
    end
  end

  it "should reject invalid email addresses" do
    emails =  %w[user@foo,com user_at_foo.org example.user@foo.] 
    emails.each do |email|
      invalid_email_user = User.new(@attr.merge(:email => email))
      invalid_email_user.should_not be_valid
    end
  end

  it "should reject duplicate email addresses" do
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  it "should reject duplicate email addresses regardless of case" do
    upper_case_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upper_case_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end


  describe "password validations" do

    it "should require a password" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).should_not be_valid
    end

    it "should require a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => "invalid")).should_not be_valid
    end

    it "should reject short passwords" do
      short = "a" * 5
      User.new(@attr.merge(:password => short, :password_confirmation => short)).should_not be_valid
    end

    it "should reject long passwords" do
      long = "a" * 41
      User.new(@attr.merge(:password => long, :password_confirmation => long)).should_not be_valid
    end

  end


  describe "password encryption" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should have an encrypted password" do
      @user.should respond_to(:password_digest)
    end

  end

  describe "admin attribute" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should respond to admin" do
      @user.should respond_to(:admin)
    end

    it "should not be an admin by default" do
      @user.should_not be_admin
    end

    it "should be convertible to an admin" do
      @user.toggle!(:admin)
      @user.should be_admin
    end
  end

  describe "microposts association" do

    before(:each) do
      @user = User.create(@attr)
      @p1 = Factory(:micropost, :user => @user, :created_at => 1.day.ago)
      @p2 = Factory(:micropost, :user => @user, :created_at => 1.hour.ago)
    end

    it "should have a microposts attribute" do
      @user.should respond_to :microposts
    end

    it "should have the right posts in descending order of creation time" do
      @user.microposts.should == [@p2, @p1]
    end

    it "should destroy associated microposts when user is deleted" do
      @user.destroy
      [@p1, @p2].each do |p|
        Micropost.find_by_id(p.id).should be_nil
      end
    end

    describe "status feed" do

      it "should have a status feed" do
        @user.should respond_to :feed
      end

      it "should include the user's microposts" do
        @user.feed.should include(@p1)
        @user.feed.should include(@p2)
      end

      it "should not include a different user's microposts" do
        p3 = Factory(:micropost, :user => Factory(:user, :email => Factory.next(:email)))
        @user.feed.should_not include p3
      end

      it "should include the microposts of a followed user" do
        followed = Factory(:user, :email => Factory.next(:email))
        p3 = Factory(:micropost, :user => followed)
        @user.follow! followed
        @user.feed.should include p3
      end
    end
  end

  describe "relationships" do

    before(:each) do
      @user = User.create!(@attr)
      @followed = Factory :user
    end

    it "should have a relationships method" do
      @user.should respond_to :relationships
    end

    it "should have a following method" do
      @user.should respond_to :following
    end

    it "should have a following? method" do
      @user.should respond_to :following?
    end

    it "should have a follow! method" do
      @user.should respond_to :follow!
    end

    it "should follow another user" do
      @user.follow!(@followed)
      @user.should be_following @followed
    end

    it "should include the user in the following array" do
      @user.follow! @followed
      @user.following.should include @followed
    end

    it "should have an unfollow! method" do
      @user.should respond_to :unfollow!
    end
    
    it "should unfollow a user" do
      @user.follow! @followed
      @user.unfollow! @followed
      @user.should_not be_following @followed
    end

    it "should have a reverse relationships model" do
      @user.should respond_to :reverse_relationships
    end

    it "should have a followers method" do
      @user.should respond_to :followers
    end

    it "should include the follower in the followers result" do
      @user.follow! @followed
      @followed.followers.should include @user
    end

  end
end
