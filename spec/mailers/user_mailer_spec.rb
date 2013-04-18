require "spec_helper"

describe UserMailer do
  let(:user) { FactoryGirl.create(:user) }
  describe "password_reset" do
    
    # let!(:mail) { UserMailer.password_reset(user).deliver }
    let!(:mail) { user.send_password_reset_email }


    # subject { mail }

    it "renders the headers" do
      mail.subject.should == 'Password Reset Instructions for Application'
      mail.to.should == [user.email]
      mail.from.should == ['from@example.com']
      # its(:subject) { should == 'Password Reset Instructions for Application' }
      # its(:to) { should == 'user@example.com' }
      # its(:from) { should == 'parthpatel.org@gmail.com' }
    end

    it "greets the user by name" do
      mail.body.encoded.should match(user.name)
    end

    it "contains password reset url" do
      mail.body.encoded.should have_link('Reset Password', 
        href: edit_password_reset_url(user.password_reset_token))
    end
  end

  describe "signup_confirmation" do
    let(:confirmation) { user.send_singup_confirmation_email }

    it "should render the headers" do
      confirmation.subject.should == "Account activation instructions for Application"
      confirmation.to.should == user.email
      confirmation.from.should == activation@application.com
    end

    it "greets the user correctly" do
      confirmation.body.encoded.should match(user.name)
    end

    it "contains signup confirmation url" do
      confirmation.body.encoded.should have_link('Activate My Account',
          href: confirm_user_path(user.remember_token))
    end
  end
end