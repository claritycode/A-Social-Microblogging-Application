require 'spec_helper'

describe ApplicationHelper do

  describe "full_title" do
    it "should include the page title" do
      full_title("xyz").should =~ /xyz/
    end

    it "should include the base title" do
      full_title("").should =~ /^Application/
    end
  end
end