require 'spec_helper'

describe "User Pages" do
  subject { page }

    	describe "signup page" do
    		before { visit signup_path }

    		it { should have_selector('h1',    text: 'Sign up') }
  	    it { should have_selector('title', text: full_title('Sign up')) }
    	end

  	  describe "signup" do
  	    before { visit signup_path }
  	    let(:submit) { "Create my account" }  

  	    describe "with invalid information" do
  	    	it "should not create valid user" do
  	    		expect { click_button submit }.not_to change(User, :count) #Capybara Syntax
  	    	end
  	    end

  	    describe "with valid information" do
  	    	before do 
  	    		fill_in "Name", with: "Example User"
  	    		fill_in "Email", with: "user@example.com"
  	    		fill_in "Username", with: "uexample"
  	    		fill_in "Password", with: "project8"
  	    		fill_in "Confirmation", with: "project8"
  	    	end
  	    	
  	    	it "should create valid user" do
  	    		expect { click_button submit }.to change(User, :count).by(1) #Capybara Syntax
  	    	end

  	    	describe "after saving the user" do
  		        before { click_button submit }
  		        let(:user) { User.find_by_email('user@example.com') }

  		        it { should have_selector('title', text: full_title(user.name)) }
  		        it { should have_selector('div.alert.alert-success', 
  		        							text: 'Welcome') }
  		        it { should have_link('Sign Out') } #SingUp followed by user profile
        		end
  	    end

  	    describe "after submission" do
  	        before { click_button submit }

  	        it { should have_selector('title', text: 'Sign up') }
  	        it { should have_content('error') }
        end
  	  end

  	  describe "profile page" do 
    		let(:user) { FactoryGirl.create(:user) }
        let!(:m1) { FactoryGirl.create(:micropost, user: user, content: "Test") }
        let!(:m2) { FactoryGirl.create(:micropost, user: user, content: "Beta") }
    		before { visit user_path(user) }

    		it { should have_selector('h1', text: user.name) }
    		it { should have_selector('title', text: full_title(user.name)) }

        #........Microposts..................

        describe "microposts" do

          it { should have_content(m1.content) }
          it { should have_content(m2.content) }
          it { should have_content(user.microposts.count) }
        end

        describe "follow/unfollow button" do
          let(:other_user) { FactoryGirl.create(:user) }
          before { sign_in user }

          describe "following a user" do
            before { visit user_path(other_user) }

            it "should increment user's followed" do
              expect do
                click_button 'Follow'
              end.to change(user.followed_users, :count).by(1)
            end

            it "should increment other user's followers" do
              expect do
                click_button 'Follow'
              end.to change(other_user.followers, :count).by(1)
            end

            describe "toggling follow/unfollow button" do
              before { click_button 'Follow' }

              it { should have_selector('input', value: 'Unfollow') }
            end
          end

          describe "unfollowing a user" do
            before do
              user.follow!(other_user)
              visit user_path(other_user)
            end

            it "should decrement user's followed" do
              expect do
                click_button 'Unfollow'
              end.to change(user.followed_users, :count).by(-1)
            end

            it "should decrement other user's followers" do
              expect do
                click_button 'Unfollow'
              end.to change(other_user.followers, :count).by(-1)
            end

            describe "toggling follow/unfollow button" do
              before { click_button 'Unfollow' }

              it { should have_selector('input', value: 'Follow') }
            end

          end
        end  
     	end

     	describe "edit" do
     		let(:user) { FactoryGirl.create(:user) }
     		before do
     			sign_in user
     			visit edit_user_path(user)
     		end
     		   		
     		describe "page" do

     			it { should have_selector('h1', text: 'update your profile') }
     			it { should have_selector('title', text: 'Edit user') }
     			it { should have_link('change', href: 'http://gravatar.com/emails') }
     		end

     		describe "with invalid information" do
     			before { click_button 'Save changes' }

     			it{ should have_content('error') }
     		end

     		describe "with valid information" do
     			let(:new_name) { 'New Name' }
     			let(:new_email) { 'new_email@example.com' }
     			before do
     				fill_in "Name", with: new_name
     				fill_in "Email", with: new_email
     				fill_in "Username", with: user.username
     				fill_in "Password", with: user.password
     				fill_in "Confirm Password", with: user.password
     				click_button "Save changes"
     			end

     			it { should have_selector('title', text: new_name) }
     			it { should have_selector('div.alert.alert-success') }
     			it { should have_link('Sign Out', href: signout_path) }
     			specify { user.reload.name.should == new_name }
     			specify { user.reload.email.should == new_email }
     		end
     	end

      describe "index" do
        let(:user) { FactoryGirl.create(:user) }
        before do
          sign_in user
          visit users_path
        end

        it { should have_selector('title', text: full_title('All users')) }
        it { should have_selector('h1',    text: 'All users') }

        describe "Pagination" do
          before(:all) { 30.times do FactoryGirl.create(:user) end }
          after(:all) { User.delete_all } 

          it { should have_selector('div.pagination') }

          it "should list each user" do
            User.paginate(page: 1).each do |user|
            page.should have_selector('li', text: user.name)
            end 
          end
        end

        describe "delete links" do

          it { should_not have_link('delete') }

          describe "as an admin" do
            let(:admin) { FactoryGirl.create(:admin) }
            before do
              sign_in admin
              visit users_path
            end

            it { should have_link('delete', href: user_path(User.first)) }
            it "should be able to delete users" do
              expect { click_link('delete').to change(User, :count).by(-1) }
            end

            it { should_not have_link('delete', href: user_path(admin)) }
          end
        end
      end

      describe "followers/following" do
        let(:user) { FactoryGirl.create(:user) }
        let(:other_user) { FactoryGirl.create(:user) }
        before { user.follow!(other_user) }

        describe "following" do
          before do
            sign_in user
            visit following_user_path(user)
          end

          it { should have_selector('title', text: 'Following') }
          it { should have_selector('h3', text: 'Following') }
          it { should have_link(other_user.name, href: user_path(other_user)) }
        end

        describe "followers" do
          before do
            sign_in other_user
            visit followers_user_path(other_user)
          end

          it { should have_selector('title', text: 'Followers') }
          it { should have_selector('h3', text: 'Followers') }
          it { should have_link(user.name, href: user_path(user)) }
        end
      end

      describe "mentions" do
        let!(:user) { FactoryGirl.create(:user, username: "user") }
        let!(:other_user) { FactoryGirl.create(:user, username: "otheruser") }
        let!(:m1) { FactoryGirl.create(:micropost, 
          content: "Lorem @user", user: other_user) }
        
        before do
          sign_in user
          visit mentions_user_path(user)
        end

        it { should have_selector('title', text: "Mentions") }
        it { should have_selector('h3', text: "Mentions") }

        describe "should have microposts where the current user is mentioned" do

          it { should have_content(m1.content) }
        end
      end

      describe "favorites" do
        let(:user) { FactoryGirl.create(:user) }
        let(:other_user) { FactoryGirl.create(:user) }
        let!(:m1) { FactoryGirl.create(:micropost, 
                      user: other_user) }
        before do
          user.favorite!(m1)
        end

        describe "favorite page" do
          before do
            sign_in user
            visit favorites_user_path(user)
          end

          it { should have_selector('title', text: 'Favorites') }
          it { should have_selector('h3', text: 'Favorites') }
          it { should have_content(m1.content) }
          it { should have_content(user.favorites.count) }
        end
      end
end