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
#

class User < ActiveRecord::Base
  has_secure_password
  #  attr_accessible is for explicitly telling what accessors may be used. 
  attr_accessible :name, :email, :password, :password_confirmation

  self.per_page = 10

  validates :name, :presence => true,
                   :length => { :maximum => 50 }

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, :presence => true,
                    :format => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false }

  validates :password, :presence => { :on => :create },
                       :length => { :within => 6..40 }

  def self.authenticate_with_token(id, salt)
    user = User.find_by_id(id)
    (user && user.created_at.to_i == salt) ? user : nil
  end
end
