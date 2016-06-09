require 'spec_helper'

module ChangeManager
	describe LocalManager do

		describe '#queue_change' do
			let(:queued_change) { LocalManager.queue_change('test', 'removed_as_delegate', 'work_id1', 'testemail@gmail.com') }
			
			it 'should spawn a background worker' do
				queued_change.should be_truthy
			end

		end

		describe '#process_change' do
			let(:cancelled_change) { FactoryGirl.create(:change, cancelled: true)}
			let(:change) { FactoryGirl.create(:change) }
			
			it 'should do nothing if initial change is cancelled' do
				LocalManager.process_change(cancelled_change.id).should be_nil
			end
			
			it 'should execute if initial change isn\'t cancelled' do
				LocalManager.process_change(change.id).should be_truthy
			end
		
		end

		describe '#process_changes_similar_to:' do
			let!(:initial_change) { Change.find(Change.new_change('owner', 'added_as_editor', 'work_id1', 'target')) }
			let!(:initial_change_id) { initial_change.id }
			let(:processed_changes) { LocalManager.process_changes_similar_to initial_change }
		
			# describe the different changes
			# non-cancelled (related) inverse changes (neither should be loaded into similar changes)
			context 'inverse changes' do
				let!(:initial_change) { Change.find(Change.new_change('owner', 'added_to_group', 'work_id1', 'target'))}
				let!(:noninverse_change) { Change.find(Change.new_change('owner', 'added_to_group', 'work_id4', 'target')) }
				let!(:first_inverse_change) { Change.find(Change.new_change('owner', 'added_as_delegate', 'work_id1', 'target')) }
				let!(:next_inverse_change) { Change.find(Change.new_change('owner', 'removed_as_delegate', 'work_id1', 'target')) }
				
				after {
					first_inverse_change.cancelled = false
					next_inverse_change.cancelled = false
				}
				
				it 'should not be loaded into the array' do
					expect(processed_changes).to include(initial_change)
					expect(processed_changes).to include(noninverse_change)
					expect(processed_changes).not_to include(first_inverse_change)
					expect(processed_changes).not_to include(next_inverse_change)
				end

				context 'with three or more inverse changes' do
					let!(:third_inverse_change) { Change.find(Change.new_change('owner', 'added_as_delegate', 'work_id1', 'target')) }
					
					it 'should only remove n - 1 changes' do
						expect(processed_changes).to include(third_inverse_change)
					end

				end

			end		

		end

		describe '#group_similar_changes' do
			# unrelated changes (owner and target aren't the same as initial - cancelled doesnt matter)
			let!(:initial_change) { Change.find(Change.new_change('owner', 'added_as_editor', 'work_id1', 'target')) }
			let(:similar_changes) { LocalManager.group_similar_changes(initial_change.owner, initial_change.target) }
			
			context 'unrelated changes' do
				# same owner & target
				let!(:related_change) { Change.find(Change.new_change('owner', 'added_as_delegate', 'work_id1', 'target')) }
				# same owner, different target
				let!(:so_change) { Change.find(Change.new_change('owner', 'added_to_group', 'work_id2', 'target2')) }
				# different owner, same target
				let!(:st_change) { Change.find(Change.new_change('owner1', 'added_to_group', 'work_id2', 'target')) }
				# load everything into array, give length for comparison (there should only be 2: initial change and related_notification)
				
				it 'should not be loaded into the array' do
					expect(similar_changes).to include(initial_change)
					expect(similar_changes).to include(related_change)
					expect(similar_changes).not_to include(so_change)
					expect(similar_changes).not_to include(st_change)
				end

			end

			# cancelled related changes (owner and target are the same as initial - shouldn't be loaded into similar_changes)
			context 'cancelled related changes' do 
				let!(:cancelled_change) { Change.find(Change.new_change('owner', 'added_to_group', 'work_id4', 'target')) }
				let!(:noncancelled_change) { Change.find(Change.new_change('owner', 'added_as_delegate', 'work_id1', 'target')) }
				
				before { cancelled_change.cancel }

				it 'should not be loaded into the array' do
					expect(similar_changes).to include(initial_change)
					expect(similar_changes).to include(noncancelled_change)
					expect(similar_changes).not_to include(cancelled_change)
				end

			end
		end
		describe '#notify_target_of' do
			let!(:initial_change) { Change.find(Change.new_change('owner', 'added_as_delegate', 'work_id1', 'target')) }
			let!(:second_change) { Change.find(Change.new_change('owner', 'added_as_delegate', 'work_id1', 'target')) }
			let!(:third_change) { Change.find(Change.new_change('owner', 'added_as_delegate', 'work_id1', 'target')) }
			let(:changes) { LocalManager.group_similar_changes(initial_change.owner, initial_change.target) }

			before { LocalManager.notify_target_of changes }
			
			it 'should set the notified value of each time to a DateTime' do
				changes.each do |change|
					change.notified.should be_a(ActiveSupport::TimeWithZone)
				end
			end
		end
	end
end
