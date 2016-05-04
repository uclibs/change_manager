require 'spec_helper'

module NotificationManager
	describe Manager do
		describe '#notification' do
			let(:notification) { Manager.notification('test', 'removed_as_delegate', 'work_id1', 'testemail@gmail.com') }
			it 'should spawn a background worker' do
				notification.should be_true
			end
		end
		describe '#notify' do
			let(:cancelled_notification) { FactoryGirl.create(:notification, cancelled: true)}
			let(:notification) { FactoryGirl.create(:notification) }
			it 'should do nothing if initial change is cancelled' do
				Manager.notify(cancelled_notification.id).should be_nil
			end
			it 'should execute if initial change isn\'t cancelled' do
				Manager.notify(notification.id).should_not be_nil
			end
		end
		describe '#group_similar_changes:' do
			let!(:initial_change) { Notification.find(Notification.new_notification('owner', 'added_as_editor', 'work_id1', 'target'))}
			let(:possible_similar_changes) { Manager.group_similar_changes(initial_change.owner, initial_change.target) }
		# describe the different changes
			# unrelated changes (owner and target aren't the same as initial - cancelled doesnt matter)
			context 'unrelated changes' do
				# same owner & target
				let!(:related_notification) { Notification.find(Notification.new_notification('owner', 'added_as_delegate', 'work_id1', 'target')) }
				# same owner, different target
				let!(:so_notification) { Notification.find(Notification.new_notification('owner', 'added_to_group', 'work_id2', 'target2')) }
				# different owner, same target
				let!(:st_notification) { Notification.find(Notification.new_notification('owner1', 'added_to_group', 'work_id2', 'target')) }
				# load everything into array, give length for comparison (there should only be 2: initial change and related_notification)
				
				it 'should not be loaded into the array' do
					expect(possible_similar_changes).to include(initial_change)
					expect(possible_similar_changes).to include(related_notification)
					expect(possible_similar_changes).not_to include(so_notification)
					expect(possible_similar_changes).not_to include(st_notification)
				end
			end

			# cancelled related changes (owner and target are the same as initial - shouldn't be loaded into similar_changes)
			context 'cancelled related changes' do 
				let!(:cancelled_notification) { Notification.find(Notification.new_notification('owner', 'added_to_group', 'work_id4', 'target')) }
				let!(:noncancelled_notification) { Notification.find(Notification.new_notification('owner', 'added_as_delegate', 'work_id1', 'target')) }
				before { cancelled_notification.cancel }
				it 'should not be loaded into the array' do
					expect(possible_similar_changes).to include(initial_change)
					expect(possible_similar_changes).to include(noncancelled_notification)
					expect(possible_similar_changes).not_to include(cancelled_notification)
				end
			end
			# non-cancelled (related) inverse changes (neither should be loaded into similar changes)
			context 'inverse changes' do
				let!(:initial_change) { Notification.find(Notification.new_notification('owner', 'added_to_group', 'work_id1', 'target'))}
				let!(:noninverse_notification) { Notification.find(Notification.new_notification('owner', 'added_to_group', 'work_id4', 'target')) }
				let!(:first_inverse_notification) { Notification.find(Notification.new_notification('owner', 'added_as_delegate', 'work_id1', 'target')) }
				let!(:next_inverse_notification) { Notification.find(Notification.new_notification('owner', 'removed_as_delegate', 'work_id1', 'target')) }
				it 'should not be loaded into the array' do
					expect(possible_similar_changes).to include(initial_change)
					expect(possible_similar_changes).to include(noninverse_notification)
					expect(possible_similar_changes).not_to include(first_inverse_notification)
					expect(possible_similar_changes).not_to include(next_inverse_notification)
				end
				context 'with three or more inverse changes' do
					let!(:third_inverse_notification) { Notification.find(Notification.new_notification('owner', 'added_as_delegate', 'work_id1', 'target')) }
					it 'should only remove n - 1 changes' do
						expect(possible_similar_changes).to include(third_inverse_notification)
					end
				end
			end			
		end
	end
end
