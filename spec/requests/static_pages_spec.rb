require 'spec_helper'

describe "Static pages" do

  subject { page }

  shared_examples_for "all static pages" do
    it { should have_selector('h1',    text: heading) }
    it { should have_selector('title', text: full_title(page_title)) }
  end

  describe "Home page" do
    before { visit root_path }
    let(:heading)    { 'Application' }
    let(:page_title) { '' }

    it_should_behave_like "all static pages"
    it { should_not have_selector 'title', text: '| Home' }
  end

  describe "Help page" do
    before { visit help_path }
    let(:heading) { 'Help' }
    let(:page_title) { 'Help' }

    it_should_behave_like "all static pages"
  end

  describe "About page" do
    before { visit about_path }
    let(:heading) { 'About Us' }
    let(:page_title) { 'About Us' }

    it_should_behave_like "all static pages"
  end

  describe "Contact page" do
    before { visit contact_path }
    let(:heading) { 'Contact' }
    let(:page_title) { 'Contact' }

    it_should_behave_like "all static pages"
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    page.should have_selector 'title', text: full_title('About Us')
    click_link "Help"
    page.should have_selector 'title', text: full_title('Help')
    click_link "Contact"
    page.should have_selector 'title', text: full_title('Contact')
    click_link "Home"
    click_link "Sign up now!"
    page.should have_selector 'title', text: full_title('Sign up')
    click_link "Application"
    page.should have_selector 'title', text: full_title('')
  end

  describe "for signed in users" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
      FactoryGirl.create(:micropost, user: user, content: "dhkgh hdfgh")
      sign_in user
      visit root_path
    end

    it "should render user's feed" do
      user.feed.each do |item|
        page.should have_selector("li##{item.id}", text: item.content)
        #page.should have_link('delete', href: micropost_path(item))
      end
    end

    describe "following/followers" do
      let(:other_user) { FactoryGirl.create(:user) }
      before do
        other_user.follow!(user)
        visit root_path
      end

      it { should have_link('0 following',
             href: following_user_path(user)) }

      it { should have_link('1 followers', 
              href: followers_user_path(user)) }
    end


    describe "favorites counts" do
      let(:other_user) { FactoryGirl.create(:user) }
      let(:m1) { FactoryGirl.create(:micropost, 
                  user: other_user) }
      before do
        user.favorite!(m1)
        visit root_path
      end

      it { should have_link('1 favorites', 
            href: favorites_user_path(user)) }
    end

    describe "favorite/unfavorite" do
          # let(:other_user) { FactoryGirl.create(:user) }
          # let(:m1) { FactoryGirl.create(:micropost, 
                      # user: other_user) }

          describe "favoriting a micropost" do
            # before { visit root_path }
            it "should increment user's favorites" do
              expect do
                click_button 'Favorite'
              end.to change(user.favorited_microposts, :count).by(1)
            end

            describe "toggling favorite/favorited" do
              before { click_button 'Favorite' }

              it { should have_selector('input', value: 'Favorited') }
            end
          end

          describe "unfavoriting a micropost" do
            # before { visit root_path }
            before do
              click_button 'Favorite'
              visit root_path
            end
            it "should decrement user's favorites" do
              expect do
                click_button 'Favorited'
              end.to change(user.favorited_microposts, :count).by(-1)
            end

            describe "toggling favorite/favorited" do
              before { click_button 'Favorited' }

              it { should have_selector('input', value: 'Favorite') }
            end
          end
        
    end
  end
end
