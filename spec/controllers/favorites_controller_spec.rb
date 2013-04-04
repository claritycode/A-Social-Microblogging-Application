require 'spec_helper'

describe FavoritesController do

  let(:user) { FactoryGirl.create(:user) }
  let(:other_user) { FactoryGirl.create(:user) }
  let!(:m1) { FactoryGirl.create(:micropost, user: other_user) }

  before { sign_in user }

  describe "creating a favorite with Ajax" do

    it "should increment the Favorite count" do
      expect do
        xhr :post, :create, favorite: { micropost_id: m1.id }
      end.to change(Favorite, :count).by(1)
    end

    it "should respond with success" do
      xhr :post, :create, favorite: { micropost_id: m1.id }
      response.should be_success
    end
  end

  describe "destroying a favorite with Ajax" do

    before { user.favorite!(m1) }
    let(:favorite) { user.favorites.find_by_micropost_id(m1) }

    it "should decrement the favorites count" do
      expect do
        xhr :delete, :destroy, id: favorite.id
      end.to change(Favorite, :count).by(-1)
    end

    it "should respond with success" do
      xhr :delete, :destroy, id: favorite.id
      response.should be_success
    end
  end
end