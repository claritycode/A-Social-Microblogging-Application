# == Schema Information
#
# Table name: microposts
#
#  id         :integer          not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Micropost do
  let(:user) { FactoryGirl.create(:user) }
  before do
  	#@micropost = Micropost.new(content: "Lorem ipsum", user_id: user.id)
  	@micropost = user.microposts.build(content: "Lorem ipsum")
  end

  subject { @micropost }

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should == user }
  it { should respond_to(:mentions) }

  it { should be_valid }

  describe "When user_id is not present" do
  	before { @micropost.user_id = nil }

  	it { should_not be_valid }
  end

  describe "accessible attributes" do
  	it "should not allow acces to user_id" do
  		expect do
  			Micropost.new(user_id: user.id)
  		end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
  	end
  end

  describe "when the content is not present" do
    before { @micropost.content = " " }

    it { should_not be_valid }
  end

  describe "when the content is too long" do
    before { @micropost.content = "a" * 141 }

    it { should_not be_valid }
  end

  describe "mention associations" do

    before { @micropost.save }
    let(:other_user) { FactoryGirl.create(:user, 
        username: 'otheruser') }
    let!(:mention1) { @micropost.mentions.create!(user_id: user.id) }
    let!(:mention2) { @micropost.mentions.create!(user_id: other_user.id) }
    # subject { m1 }

    it "should destroy associated mentions" do
      m1 = @micropost.mentions.dup
      @micropost.destroy
      m1.should_not be_empty
      m1.each do |mention|
        Mention.find_by_id(mention.id).should be_nil
      end
    end
  end
end
