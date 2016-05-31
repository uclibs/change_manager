module ChangeManager
	class Manager
		def self.queue_change(owner, change_type, context, target)
			change_id = Change.new_change(owner, change_type, context, target)
			# Resque.enqueue(MakeChange, change_id)
			Resque.enqueue_in(5.minutes, ChangeManager::BeginChange, change_id)
		end

		def self.process_change(change_id)
			unless Change.find(change_id).cancelled?
				change = Change.find change_id
				verified_changes = process_changes change
				notify verified_changes unless verified_changes.empty?
			end
		end

		private
		def self.process_changes(change)
			cancel_all_changes(group_similar_changes(change.owner, change.target))
		end

		def self.group_similar_changes(owner, target)
			similar_changes = Change.where(owner: owner, target: target, cancelled: false)
			if similar_changes.length > 1
				cancel_inverse_changes(similar_changes)
			end
			return similar_changes
		end

		def self.cancel_inverse_changes(similar_changes)
			similar_changes.each do |change|
				similar_changes.each do |next_change|
					if change.inverse_of?(next_change)
						change.cancel
						next_change.cancel
						puts 'cancelled inverse changes ' + change.change_type + ' and ' + next_change.change_type
						similar_changes.delete_if { |change| change.cancelled? }
					end
				end
			end
			return similar_changes
		end

		def self.cancel_all_changes(verified_changes)
			verified_changes.each do |change|
				change.cancel
			end
			verified_changes
		end

		def self.notify(changes)
			mailer = ChangeManager::NotificationMailer
			if mailer.send_email(mailer.construct_email(changes))
				changes.each do |change|
					change.notify
				end
				return true
			end
			false
		end
	end
end
