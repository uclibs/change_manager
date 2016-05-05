module NotificationManager
	class Manager
		def self.notification(owner, change_type, context, target)
			change_id = Notification.new_notification(owner, change_type, context, target)
			Resque.enqueue(MakeChange, change_id)
			# Resque.enqueue_in(
			# 	30.seconds,
			# 	MakeChange,
			# 	change_id
			# 	)
		end

		def self.notify(change_id)
			puts 'the notify method was called'
			unless Notification.find(change_id).cancelled?
				change = Notification.find(change_id)
				similar_changes = group_similar_changes(change.owner, change.target)
				mailer = NotificationManager::NotificationMailer
				mailer.send_email(mailer.construct_email(similar_changes))
			end
		end

		def self.group_similar_changes(owner, target)
			similar_changes = Notification.where(owner: owner, target: target, cancelled: false)
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
						similar_changes.delete_if { |change| change.cancelled? }
					end
				end
			end
			return similar_changes
		end
	end
end
