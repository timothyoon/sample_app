require 'spec_helper'

describe User do
  
  before(:each) do
    @attr = { :name => "Example User", 
              :email => "user@example.com",
              :password => "foobar",
              :password_confirmation => "foobar" }
  end
  
  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end
  
  ###############################################
  # Name tests
  ###############################################
  
  it "should require a name" do
    no_name_user = User.new(@attr.merge(:name => ""))
    no_name_user.should_not be_valid
  end
  
  it "should require an email address" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end
  
  it "should reject names that are too long" do
    long_name = "a" * 51
    long_name_user = User.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end
  
  it "should reject names that are too short" do
    short_name = "a" * 2
    short_name_user = User.new(@attr.merge(:name => short_name))
    short_name_user.should_not be_valid
  end
  
  
  ###############################################
  # Email tests
  ###############################################
  
  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.au]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end
  
  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end
  
  it "should reject duplicate email addresses" do
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end
  
  it "should reject duplicate email addresses regardless of case" do
    upper_case_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upper_case_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end
  
  
  ###############################################
  # Password tests
  ###############################################
  describe "password validations" do
    
    it "should require a passwoord" do
      hash = @attr.merge(:password => "", :password_confirmation => "")
      User.new(hash).should_not be_valid
    end
    
    it "should require a matching password confirmation" do
      hash = @attr.merge(:password_confirmation => "invalid")
      User.new(hash).should_not be_valid
    end
    
    it "should reject short passwords" do
      short = "a" * 5
      hash = @attr.merge(:password => short, :password_confirmation => short)
      User.new(hash).should_not be_valid
    end
    
    it "should reject long passwords" do
      long = "a" * 41
      hash = @attr.merge(:password => long, :password_confirmation => long)
      User.new(hash).should_not be_valid
    end
    
    ###############################################
    # Password encryption tests
    ###############################################
    describe "password encryption" do
      
      before(:each) do
        @user = User.create!(@attr)
      end
      
      it "should have an encrypted password attribute" do
        @user.should respond_to(:encrypted_password)
      end
      
      it "should set the encrypted password" do
        @user.encrypted_password.should_not be_blank
      end
      
      describe "has_password? method" do
        
        it "should be true if the passwords match" do
          @user.has_password?(@attr[:password]).should be_true
        end
        
        it "should be false if the passwords don't match" do
          @user.has_password?("invalid").should be_false
        end
        
      end
      
      describe "authenticate method" do
        
        it "should return nil on email/password mismatch" do
          wrong_password_user = User.authenticate(@attr[:email], "wrongpassword")
          wrong_password_user.should be_nil
        end
        
        it "should return nil when no user exists for an email address" do
          wrong_password_user = User.authenticate("unknown@user.com", @attr[:password])
          wrong_password_user.should be_nil
        end
        
        it "should return the user on valid credentials" do
          wrong_password_user = User.authenticate(@attr[:email], @attr[:password])
          wrong_password_user.should == @user
        end
        
      end
      
    end
    
    ###############################################
    # Admin user tests
    ###############################################
    describe "admin attribute" do
      
      before(:each) do
        @user = User.create!(@attr)
      end
      
      it "should respond to admin" do
        @user.should respond_to(:admin)
      end
      
      it "should not be an admin by default" do
        @user.should_not be_admin
      end
      
      it "should be convertable to an admin" do
        @user.toggle!(:admin)
        @user.should be_admin
      end
      
    end
    
    ###############################################
    # Micropost association tests
    ###############################################
    describe "micropost associations" do

      before(:each) do
        @user = User.create(@attr)
        @mp1 = Factory(:micropost, :user => @user, :created_at => 1.day.ago)
        @mp2 = Factory(:micropost, :user => @user, :created_at => 1.hour.ago)
      end

      it "should have a microposts attribute" do
        @user.should respond_to(:microposts)
      end
      
      it "should have a microposts attribute" do
        @user.should respond_to(:microposts)
      end

      it "should have the right microposts in the right order" do
        @user.microposts.should == [@mp2, @mp1]
      end
      
      it "should destroy the associated posts" do
        @user.destroy
        [@mp1, @mp2].each do |micropost|
          Micropost.find_by_id(micropost.id).should be_nil
        end
      end
      
      it "should destroy the associated posts" do
        @user.destroy
        [@mp1, @mp2].each do |micropost|
          lambda do 
            Micropost.find(micropost.id)
          end.should raise_error(ActiveRecord::RecordNotFound)
        end
      end
      
    end
      
  end
  
end
