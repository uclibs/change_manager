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

		# run populate_test_data from console
		def self.notify(change_id)
			puts 'the notify method was called'
			unless Notification.find(change_id).cancelled?
				change = Notification.find(change_id)
				similar_changes = group_similar_changes(change.owner, change.target)
				puts 'group_similar_changes finished. size: ' + similar_changes.length.to_s
				mailer = NotificationManager::NotificationMailer
				mailer.send_email(mailer.construct_email(similar_changes))
			end
		end

		def self.group_similar_changes(owner, target)
			similar_changes = Notification.where(
				owner: owner, 
				target: target, 
				cancelled: false
				)
			puts 'size before inverses: ' + similar_changes.length.to_s
			cancel_inverse_changes(similar_changes)
			puts 'size after inverses: ' + similar_changes.length.to_s
			return similar_changes
		end

		def self.cancel_inverse_changes(similar_changes)
			similar_changes.map { |change| cancel_inverse_change(similar_changes, change)  }
			similar_changes.delete_if { |change| change.cancelled? }
		end

		def self.cancel_inverse_change(similar_changes, change)
			similar_changes.each do |next_change|
				if change.inverse_of?(next_change.change_type)
					change.cancel
					next_change.cancel
				end
			end
			return similar_changes
		end

		def self.populate_test_data
			#move to spec
			NotificationManager::Notification.new_notification('kyle', 'added_as_delegate', 'work_id1', 'kylelawhorn@gmail.com')
			NotificationManager::Notification.new_notification('kyle', 'added_to_group', 'work_id2', 'kylelawhorn@gmail.com')
			NotificationManager::Notification.new_notification('kyle', 'removed_as_editor', 'work_id3', 'kylelawhorn@gmail.com')
			NotificationManager::Notification.new_notification('kyle', 'added_to_group', 'work_id4', 'kylelawhorn@gmail.com')
			NotificationManager::Manager.notification('kyle', 'removed_as_delegate', 'work_id1', 'kylelawhorn@gmail.com')
		end
	end
end
