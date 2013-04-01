# == Schema Information
#
# Table name: favorites
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  micropost_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'spec_helper'

describe Favorite do
  
  let(:user) { FactoryGirl.create(:user) }
  let(:micropost) { FactoryGirl.create(:micropost,
  						user: user) }

  before do
  	# @favorite = Favorite.new(user_id:user.id, 
  						# micropost_id: micropost.id) 
  	@favorite = user.favorites.build(micropost_id: micropost.id)
  end

  subject { @favorite }

  it { should respond_to(:user_id) }
  it { should respond_to(:micropost_id) }
  it { should respond_to(:user) }
  its(:user) { should == user }

  it { should be_valid }

  describe "when user_id is not presnt" do
  	before { @favorite.user_id = nil }

  	it { should_not be_valid }
  end

  describe "when micropost_id is not present" do
  	before { @favorite.micropost_id = nil }

  	it { should_not be_valid }
  end

  describe "accessible attributes" do
  	it "should not allow access to user_id" do
  		expect do
  			Favorite.new(user_id: user.id)
  		end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
  	end
  end

  
end
