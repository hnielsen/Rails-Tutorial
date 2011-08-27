require 'spec_helper'

describe "LayoutLinks" do

  it "Should have a Home page at /" do
    get '/'
    response.should have_selector('title', :content => "Home")
  end

  it "Should have a Contact page at /contact" do
    get '/contact'
    response.should have_selector('title', :content => "Contact")
  end

  it "Should have a About page at /about" do
    get '/about'
    response.should have_selector('title', :content => "About")
  end

  it "Should have a Help page at /help" do
    get '/help'
    response.should have_selector('title', :content => "Help")
  end

  it "Should have a Sign-up page at /signup" do
    get '/signup'
    response.should have_selector('title', :content => "Sign up")
  end

  it "Should visit the correct layout links" do
    visit root_path

    click_link "About"
    response.should have_selector('title', :content => "About")

    click_link "Help"
    response.should have_selector('title', :content => "Help")

    click_link "Contact"
    response.should have_selector('title', :content => "Contact")

    click_link "Home"
    response.should have_selector('title', :content => "Home")

    click_link "Sign up now!"
    response.should have_selector('title', :content => "Sign up")
  end

end
