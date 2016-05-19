require 'spec_helper'

module ChangeManager
    describe Change do

        it 'has a valid factory' do
        	FactoryGirl.create(:change).should be_valid
        end

        it 'should have a change_owner' do
        	FactoryGirl.build(:change, owner: nil).should_not be_valid
        end

        it 'should have a change_target' do
        	FactoryGirl.build(:change, target: nil).should_not be_valid
        end

        it 'should have a change_type' do
        	FactoryGirl.build(:change, change_type: nil).should_not be_valid
        end

        it 'should be initialized as false' do
            FactoryGirl.build(:change).cancelled.should be_false
        end

        # seperate describe blocks, wrap in context
        context 'instance method' do
            let(:cancelled_change) { FactoryGirl.build(:change, cancelled: true) }
            let(:change) { FactoryGirl.build(:change) }
            describe '#cancel' do
                after { change.cancelled = false }
            	it 'should cancel a notification' do
                    change.cancel
            		change.cancelled.should be_true
            	end
            end

            describe '#cancelled?' do
            	it 'should return whether a notification is cancelled' do
            		change.cancelled.should be_false
            		cancelled_change.cancelled?.should be_true
            	end
            end

            describe '#inverse_of?' do
                let(:inverse_change) { FactoryGirl.build(:change, change_type: 'removed_as_delegate')}
                let(:noninverse_change) { FactoryGirl.build(:change, change_type: 'added_as_editor')}
                
                it 'should accurately detect inverse changes' do
                    change.inverse_of?(inverse_change).should be_true
                end

                it 'should not detect non-inverse changes' do
                    change.inverse_of?(noninverse_change).should be_false
                end
            end
        end
    end
end
