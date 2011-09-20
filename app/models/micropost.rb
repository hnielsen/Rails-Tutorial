# == Schema Information
#
# Table name: microposts
#
#  id         :integer         not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Micropost < ActiveRecord::Base
  attr_accessible :content
  belongs_to :user

  validates_presence_of :user_id
  validates :content, :presence => true,
                      :length => { :maximum => 140 }

  default_scope :order => 'microposts.created_at DESC'
  
  # Return microposts from the users being followed by the given user
  scope :from_users_followed_by, lambda { |user| followed_by(user) }

  self.per_page = 10

  private

  def self.followed_by(user)
    following_ids = %(SELECT followed_id FROM relationships WHERE follower_id = :user_id)
    where("user_id IN (#{following_ids}) OR user_id = :user_id", { :user_id => user } )
  end
end
