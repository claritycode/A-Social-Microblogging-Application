# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  username        :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#

require 'spec_helper'

describe User do
  before { @user = User.new(name: "Example User", email: "user@example.com", 
  									username: "uexample") }

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:username) }
  it { should respond_to(:password_digest) }

  it { should be_valid }

#..................................Presence validation........................  
  	describe "when name is not present" do
  		before { @user.name = " " }

  		it { should_not be_valid }
  	end

  	describe "when email is not present" do
  		before { @user.email = " " }

  		it { should_not be_valid }
  	end

  	describe "when username is not present" do
  		before { @user.username = " " }

  		it { should_not be_valid }
  	end

#.......................Length Validation........................

  	describe "when name is too long" do
  		before { @user.name = "a" * 51 }

  		it { should_not be_valid }
  	end

#.......................Email Format validation...............

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        @user.should_not be_valid
      end      
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        @user.should be_valid
      end      
    end
  end

#........................Username Format Validation..........................

  describe "when username format is invalid" do
    it "should be invalid" do
      uname = %w[.123 LK/p\_123 @klf* l-p]
      uname.each do |invalid_uname|
        @user.username = invalid_uname
        @user.should_not be_valid
      end      
    end
  end

  describe "when username format is valid" do
    it "should be valid" do
      uname = %w[123 _tfg Tgr_]
      uname.each do |valid_uname|
        @user.username = valid_uname
        @user.should be_valid
      end      
    end   
  end

#.........................Email Uniqueness Validation...................

describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end
  
#......................Username uniqueness Validaton.........................

describe "when username is already taken" do
    before do
      user_with_same_username = @user.dup
      user_with_same_username.email = "example@user.com"
      user_with_same_username.save
    end

    it { should_not be_valid }
  end

describe "when username is already taken" do
    before do
      user_with_same_username = @user.dup
      user_with_same_username.username = @user.username.upcase
      user_with_same_username.email = "example@user.com"
      user_with_same_username.save
    end

    it { should_not be_valid }
  end

  
end

