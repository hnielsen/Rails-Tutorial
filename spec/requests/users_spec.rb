require 'spec_helper'

describe "Users" do

  describe "Signup" do

    describe "failure" do

      it "should not make a new user" do
        lambda do
          visit signup_path
          fill_in "Name",         :with => ""
          fill_in "Email",        :with => ""
          fill_in "Password",     :with => ""
          fill_in "Confirmation", :with => ""
          click_button
          response.should render_template 'users/new'
          response.should have_selector "div#error_explanation"
        end.should_not change(User, :count)
      end
    end

    describe "success" do

      it "should make a new user" do
        lambda do
          visit signup_path

          fill_in "Name",         :with => "Test User 2"
          fill_in "Email",        :with => "user@example.com"
          fill_in "Password",     :with => "secret"
          fill_in "Confirmation", :with => "secret"

          click_button

          response.should have_selector("div.flash.success", :content => "Welcome")
          response.should render_template 'users/show'
        end.should change(User, :count).by(1)
      end
    end

  end

  describe "Sign in/out" do

    describe "failure" do
      it "should not sign in an invalid user in" do
        user = User.new
        integration_test_sign_in(user)
        response.should have_selector("div.flash.error", :content => "Invalid")
      end
    end

    describe "success" do
      it "should sign in and sign out a valid user" do
        user = Factory :user
        integration_test_sign_in(user)
        controller.should be_signed_in
        click_link "Sign out"
        controller.should_not be_signed_in
      end
    end
  end
end
