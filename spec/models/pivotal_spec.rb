require 'spec_helper'

describe Pivotal do
  describe "#connect" do
    it "should connect to Pivotal Tracker with the account information in the accounts file" do
      actual_token = PivotalTracker::Client.token("missioncontrol@woofound.com", "DErBsSOcewgmb41Kn1ObP2mCUyQlWauEabdQe9sj2wOh35vTF1bqnWVR5UozwPB")

      token = Pivotal.connect

      token.should == actual_token
    end

    describe "#activity_feed" do
      it "should return the activity feed for the current tracker" do
        Pivotal.activity_feed.should_not be_empty
      end
    end

    describe "#activity_feed_for" do
      it "should return the activity feed for the selected project" do
        feed = Pivotal.activity_feed_for(1031)

        feed.first.id.should == 1031
      end
    end
  end
end