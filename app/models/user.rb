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

class User < ActiveRecord::Base
  has_secure_password
  has_many :microposts, :dependent => :destroy

  has_many :relationships, 
    :foreign_key => "follower_id", 
    :dependent => :destroy
  has_many :following, :through => :relationships, :source => :followed

  has_many :reverse_relationships, 
    :foreign_key => "followed_id", 
    :class_name => "Relationship", 
    :dependent => :destroy
  has_many :followers, :through => :reverse_relationships, :source => :follower

  attr_accessible :name, :email, :password, :password_confirmation

  validates :name, :presence => true,
                   :length => { :maximum => 50 }

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, :presence => true,
                    :format => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false }

  validates :password, :presence => { :on => :create },
                       :length => { :within => 6..40 }

  def feed
    Micropost.where("user_id = ?", id)
  end

  def self.authenticate_with_token(id, salt)
    user = User.find_by_id(id)
    (user && user.created_at.to_i == salt) ? user : nil
  end

  def following?(followed)
    relationships.find_by_followed_id followed
  end

  def follow!(followed)
    relationships.create!(:followed_id => followed.id)
  end

  def unfollow!(followed)
    relationships.find_by_followed_id(followed).destroy
  end
end
