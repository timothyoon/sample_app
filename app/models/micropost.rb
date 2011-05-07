# == Schema Information
# Schema version: 20110505233620
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
  
  ###############################################
  # Associations
  ###############################################
  belongs_to :user
  
  default_scope :order => 'microposts.created_at DESC'
  
  ###############################################
  # Validation methods
  ###############################################
  validates :content, :presence => true,
                      :length => { :within => 1..140 }
  validates :user_id, :presence => true
  
end
