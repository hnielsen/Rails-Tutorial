require 'spec_helper'

describe "Microposts" do

  before(:each) do
    @user = Factory :user
    integration_test_sign_in @user
  end

  describe "creation" do

    describe "failure" do

      it "should not make a new micropost" do
        lambda do
          visit root_path
          fill_in :micropost_content, :with => ""
          click_button
          response.should render_template 'pages/home'
          response.should have_selector "div#error_explanation"
        end.should_not change(Micropost, :count)
      end

    end

    describe "success" do

      it "should make a new micropost" do
        content = "Lorem ipsum content"
        lambda do
          visit root_path
          fill_in :micropost_content, :with => content
          click_button
          response.should have_selector("span.content", :content => content)
        end.should change(Micropost, :count).by(1)
      end
    end

  end

  describe "deletion" do

    it "should not show links to delete other users' micropost" do
      wrong_user = Factory(:user, :email => "newuser@example.com")
      post = Factory(:micropost, :user => wrong_user)
      visit user_path wrong_user
      response.should_not have_selector("a", :href => micropost_path(post), :content => "delete")
    end
    
    it "should show a link to delete my own microposts" do
      post = Factory(:micropost, :user => @user)
      visit user_path @user
      response.should have_selector("a", :href => micropost_path(post), :content => "delete")
    end
  end

end
