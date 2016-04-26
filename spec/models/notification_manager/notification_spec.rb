require 'spec_helper'

module NotificationManager
  describe Notification do
    it 'has a valid factory' do
    	FactoryGirl.create(:notification).should be_valid
    end
    
    it 'should have a change_owner' do
    	FactoryGirl.build(:notification, change_owner: nil).should_not be_valid
    end

    it 'should have a change_target' do
    	FactoryGirl.build(:notification, change_target: nil).should_not be_valid
    end

    it 'should have a change_type' do
    	FactoryGirl.build(:notification, change: nil).should_not be_valid
    end
    
    describe 'instance method' do
    	let(:notification) { FactoryGirl.create(:notification) }
    	let(:cancelled_notification) { FactoryGirl.create(:notification)}
    	before(:each) do
    		cancelled_notification.cancel
    	end
    	it 'cancel should cancel a notification' do
    		cancelled_notification.change_cancelled.should == true
    	end
    
    	it 'cancelled? should return whether a notification is cancelled' do
    		notification.cancelled?.should == false
    		cancelled_notification.cancelled?.should == true
    	end
    
    end
  
  end
end
