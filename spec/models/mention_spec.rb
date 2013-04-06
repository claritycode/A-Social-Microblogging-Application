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
	let(:user) { FactoryGirl.create(:user) }
	let(:micropost) { FactoryGirl.create(:micropost, user: user) }
	before do
		  @mention = Mention.new(micropost_id: micropost.id, 
		  							user_id: user.id)
	end

	subject { @mention }

	it { should respond_to(:micropost_id) }
	it { should respond_to(:user_id) }
end
