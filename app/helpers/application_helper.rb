module ApplicationHelper

  # Creates an image_tag for the site logo
  def logo
    image_tag("logo.png", :alt => "sample app", :class => "round")
  end

  # Set page title on a per-page basis
  def title
    base_title = "Ruby on Rails Tutorial Sample App"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
end
