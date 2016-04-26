require 'spec_helper'

module NotificationManager
	describe Manager do
		before {
			let(:notification) { FactoryGirl.create(:notification)}
			let(:cancelled_notification) { FactoryGirl.create(:notification, change_cancelled: true)}
		}
		it 'should queue a worker on creation' do

		end
		describe 'notify method' do

		end 
	end
end
