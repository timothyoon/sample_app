# == Schema Information
# Schema version: 20110502004931
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
  attr_accessor   :password

  attr_accessible :name,
                  :email, 
                  :password,
                  :password_confirmation
  
  
  ###############################################
  # Validation methods
  ###############################################

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :name,  :presence => true,
                    :length => { :minimum => 3, :maximum => 50 }
  
  validates :email, :presence => true,
                    :format => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false }
  
  validates :password,  :presence => true,
                        :confirmation => true,
                        :length => { :within => 6..40}
  
  ###############################################
  # Callbacks
  ###############################################
  
  before_save :encrypt_password
  
  ###############################################
  # Static Methods
  ###############################################
  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return user && user.has_password?(submitted_password) ? user : nil
  end
  
  ###############################################
  # Public Methods
  ###############################################
  
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end
  
  ###############################################
  # Override Methods
  ###############################################
  def to_s
    "ID: '#{id}', Name: '#{name}', Email: '#{email}' - (#{super})"
  end
  
  ###############################################
  # Private Methods
  ###############################################
  private
  
    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end
  
    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end
    
    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end
    
    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
  
end
