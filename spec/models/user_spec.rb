# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  email                  :string(255)
#  username               :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  password_digest        :string(255)
#  remember_token         :string(255)
#  admin                  :boolean          default(FALSE)
#  password_reset_token   :string(255)
#  password_reset_sent_at :datetime
#

require 'spec_helper'

describe User do
  before { @user = User.new(name: "Example User", email: "user@example.com", 
  									username: "example", password: "foobar", 
                    password_confirmation: "foobar") }

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:username) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:admin) }
  it { should respond_to(:microposts) } #Micropost model
  it { should respond_to(:relationships) } #Relationship Model
  it { should respond_to(:followed_users) }
  it { should respond_to(:follow!) }
  it { should respond_to(:following?) }
  it { should respond_to(:reverse_relationships) }
  it { should respond_to(:followers) }
<<<<<<< HEAD
  
=======
  it { should respond_to(:presence_in_mentions) }
  it { should respond_to(:mentioned_microposts) }
  it { should respond_to(:password_reset_token) }
  it { should respond_to(:password_reset_sent_at) }
  it { should respond_to(:send_password_reset_email) }
>>>>>>> forgot-password

  it { should be_valid }
  it { should_not be_admin }

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
  
#......................Username uniqueness Validaton.................

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

#............................For Password..............................

  describe "when password is not present" do
    before { @user.password = @user.password_confirmation = " " }

    it { should_not be_valid }
   end

  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    
    it { should be_invalid }
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
  
    it { should_not be_valid }
  end
  
  describe "when password confirmation is nil" do
    before { @user.password_confirmation = nil }
    
    it { should_not be_valid }
  end

  describe "during password reset" do
    before { @user.save }

    describe "before reset request" do

      its(:password_reset_token) { should be_blank }
      its(:password_reset_sent_at) { should be_blank }
      # it "should not have delivered any email yet" do
      #   ActionMailer::Base.deliveries.should == []
      # end
    end

    describe "after submitting request for password reset" do
      before { @user.send_password_reset_email }

      
      its(:password_reset_token) { should_not be_blank }
      its(:password_reset_sent_at) { should_not be_blank }

      it "should send an e-mail" do
        ActionMailer::Base.deliveries.last.to.should == [@user.email]
      end
    end
  end

#........................Authenticate............................

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by_email(@user.email) }

    describe "with valid password" do
      it { should == found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not == user_for_invalid_password }
      specify { user_for_invalid_password.should be_false }
    end
  end

  describe "remember token" do
    before { @user.save }

    its(:remember_token) { should_not be_blank }
  end

  describe " with admin attribute set to true" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end

    it { should be_admin }
  end

#................................Micropost................................

  describe "microposts associations" do
    before { @user.save }
    let!(:older_micropost) do 
      FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
    end

    it "should have the right microposts in the right order" do
      # This test fails as by default sqlite database returns micropost by
      #ordering through id, but this test is also an indication of the
      #fact that user.microposts method do exist and returns an aray 
      @user.microposts.should == [newer_micropost, older_micropost]
    end

    it "should destroy associated microposts" do
        microposts = @user.microposts.dup
        @user.destroy

        microposts.should_not be_empty
        microposts.each do |micropost|
          Micropost.find_by_id(micropost.id).should be_nil
        end
    end

    describe "status" do
      let(:unfollowed_post) do
        FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
      end

      let(:unfollowed_post_with_mention) do
        FactoryGirl.create(:micropost, content: "Hi @example", 
                user: FactoryGirl.create(:user) )
      end

      let(:followed_user) { FactoryGirl.create(:user) }

      before do
        @user.follow!(followed_user)
        3.times { followed_user.microposts.create!(content: "Lorem ipsum") }
        # followed_user.microposts.create!(content: "")
      end

      its(:feed) { should include(older_micropost) }
      its(:feed) { should include(newer_micropost) }
      its(:feed) { should_not include(unfollowed_post) }
      its(:feed) do
        followed_user.microposts.each do |micropost|
          should include(micropost)
        end
      end
      its(:feed) { should include(unfollowed_post_with_mention) }
    end
  end

  describe "following" do
    let(:other_user) { FactoryGirl.create(:user) }
    before do
      @user.save!
      @user.follow!(other_user)
    end

    it { should be_following(other_user) }
    its(:followed_users) { should include(other_user) }

    describe "followers" do
      subject { other_user }

      its(:followers) { should include(@user) }
    end

    describe "unfollowing" do
      before do
        @user.unfollow!(other_user)
      end

      it { should_not be_following(other_user) }
      its(:followed_users) { should_not include(other_user) }
    end
  end
end