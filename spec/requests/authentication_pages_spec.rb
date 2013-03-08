require 'spec_helper'

describe "Authentication" do
	subject { page }
#...............Test for the existence of Sign In page................
	before { visit signin_path }

	it { should have_selector('h1', text: 'Sign In') }
	it { should have_selector('title', text: full_title('Sign In')) }

	describe "signin" do
		
#..................Check for error on invalid data.................
		describe "with invalid information" do
			before { click_button 'Sign In' }

			it { should have_selector('title', text: full_title('Sign In')) }
			it { should have_selector('div.alert.alert-error', text: 'Invalid') }

			describe "after visiting another page" do
				before { click_link "Home" }
				it { should_not have_selector('div.alert.alert-error') }
			end
		end

		describe "with valid information" do
			let(:user) { FactoryGirl.create(:user) }
			before do
				fill_in "Email", with: user.email.upcase
				fill_in "Password", with: user.password
				click_button "Sign In"
			end

			it { should have_selector('title', text: user.name) }
			it { should have_link('Profile', href: user_path(user)) }
			it { should have_link('Sign out', href: signout_path) }
			it { should_not have_link('Sign In', href: signin_path) }
		end
	end
end