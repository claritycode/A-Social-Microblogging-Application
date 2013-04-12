require "spec_helper"

describe UserMailer do
  describe "password_reset" do
    let(:user) { FactoryGirl.create(:user) }
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

end