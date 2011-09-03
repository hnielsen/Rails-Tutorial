class Micropost < ActiveRecord::Base
  attr_accessible :content
  belongs_to :user

  validates_presence_of :user_id
  validates :content, :presence => true,
                      :length => { :maximum => 140 }

  default_scope :order => 'microposts.created_at DESC'
end
