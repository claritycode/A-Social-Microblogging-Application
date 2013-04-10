require 'spec_helper'

describe "Password Reset Pages" do

	subject { page }

	describe "Password Reset request page" do
		before { visit new_password_reset_path }

		it { should have_selector('title', text: 'Password Reset') }
		it { should have_selector('h1', text: 'Password Reset') }

		describe "submitting the email" do
			before do
				fill_in "Email", with: "user@example.com"
				click_button "Submit"
			end

			it { should have_selector('title', text: 'Application') }
			it { should have_content('div.alert.alert-notice', 
				text: 'check your email') }
		end
	end

end