# == Schema Information
#
# Table name: mentions
#
#  id           :integer          not null, primary key
#  micropost_id :integer
#  user_id      :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'spec_helper'

describe Mention do
	let(:user) { FactoryGirl.create(:user, username: 'user') }
	let(:other_user) { FactoryGirl.create(:user, 
				username: 'otheruser') }
	let(:micropost) { FactoryGirl.create(:micropost, 
		content: 'lorem @otheruser', user: user) }
	before do
		  # @mention = Mention.new(micropost_id: micropost.id, 
		  							# user_id: user.id)
		@mention = micropost.mentions.build(user_id: other_user.id)
	end

	subject { @mention }

	it { should respond_to(:micropost_id) }
	it { should respond_to(:user_id) }
	it { should respond_to(:micropost) }
	its(:micropost) { should == micropost }
	it { should respond_to(:user) }
	its(:user) { should == other_user }

	it { should be_valid }

	describe "when micropost_id is not present" do
		before { @mention.micropost_id = nil }

		it { should_not be_valid }
	end

	describe "when user_id is not present" do
		before { @mention.user_id = nil }

		it { should_not be_valid }
	end

	describe "accessible attributes" do
		it "should not allow access to micropost_id" do
			expect do
				Mention.new(micropost_id: micropost.id)
			end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
		end
	end
end
