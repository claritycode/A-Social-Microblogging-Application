require 'spec_helper'

describe "Authentication" do
	subject { page }
#...............Test for the existence of Sign In page................
	before { visit signin_path }

	it { should have_selector('h1', text: 'Sign In') }
	it { should have_selector('title', text: full_title('Sign In')) }
end