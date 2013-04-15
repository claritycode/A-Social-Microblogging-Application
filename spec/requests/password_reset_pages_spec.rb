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
			it { should have_selector('div.alert.alert-notice', 
				text: 'check your email') }
		end
	end

	describe "Edit" do
		let(:user) { FactoryGirl.create(:user) }

		before do
			user.send_password_reset_email
			visit edit_password_reset_path(user.password_reset_token)	
		end

		describe "Page" do
			
			it { should have_selector('title', text: 'Reset Password') }
			it { should have_selector('h1', text: 'Reset Password') }
		end

		describe "with invalid information" do
			before { click_button 'Reset Password' }

			it { should have_content('error') }
		end

		describe "with valid information" do
			# let!(:old_password) { "charusat" }
			before do
				fill_in "New Password", with: "8project"
				fill_in "Confirm New Password", with: "8project"
				click_button 'Reset Password'
			end

			it { should have_selector('title', text: 'Sign In') }
			it { should have_selector('div.alert.alert-success', 
				text: 'Your Password Reset was successful') }
			
			describe "should change the password" do
				before do
					sign_in user
				end

				it { should have_selector('title', text:'Sign In') }
				it { should have_selector('div.alert.alert-error', 
					text: 'Invalid') }
			end

			describe "trying to use same url again" do
				before do
					visit edit_password_reset_path(user.password_reset_token)
					click_button 'Reset Password'
				end

				it { should have_selector('title', text: 'Password Reset') }
				it { should have_selector('h1', text: 'Password Reset') }
				it { should have_selector('div.alert.alert-notice', text: 'Password Reset Request has expired. Please try again') }				
			end
		end

		describe "when Password reset url had already expired" do
				before do
					user.password_reset_sent_at = 5.hours.ago
					user.save
					click_button 'Reset Password'
				end

				it { should have_selector('title', text: 'Password Reset') }
				it { should have_selector('h1', text: 'Password Reset') }
				it { should have_selector('div.alert.alert-notice', text: 'Password Reset Request has expired. Please try again') }
			end
	end
end