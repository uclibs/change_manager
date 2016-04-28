module NotificationManager
	class Manager
		# NotificationManager::Manager.notification(args)
		def self.notification(change_owner, change_made, context, change_target)
			change_id = Notification.new_notification(change_owner, change_made, context, change_target)
			# queue_job(change_id)
			Resque.enqueue(MakeChange, change_id)
			# Resque.enqueue_in(
			# 	30.seconds,
			# 	MakeChange,
			# 	change_id
			# 	)
		end

		# run populate_test_data from console
		def self.notify(change_id)
			# gather all changes with same target and owner
			# put cancelled check here
			puts 'the notify method was called'
			# how to cancel it initially?
			unless NotificationManager::Notification.find(change_id).cancelled?
				change = Notification.find(change_id)
				similar_changes = group_similar_changes(
					change.change_owner, 
					change.change_target,
					change.change
					)
				# collection/hash/array of changes -> construct_email(args)
				mailer = NotificationManager::NotificationMailer
				if mailer.send_email(mailer.construct_email(similar_changes))
					puts 'the email sent'
				end
			end
		end

		def self.group_similar_changes(owner, target, change_type)
			# populate database with preset test data

			# long query where it selects all rows where change_owner and change_target 
			# are the same as original
			
			# also where cancelled is false
			
			# determine if cancelled (yaml)
				# if cancelled (do nothing)
			similar_changes = Notification.where(
				change_owner: owner, 
				change_target: target, 
				change_cancelled: false
				)
			similar_changes.each do |change|
				cancel_polar_change(change, change.change)
				if change.cancelled?
					similar_changes.delete(change)
				end
			end
			
		end
		def self.cancel_polar_change(change, change_type)
			if change.polar_change?
				change.cancel
			end
		end
		def self.populate_test_data
			#move to spec
			NotificationManager::Manager.notification('kyle', 'change1', 'work_id1', 'kylelawhorn@gmail.com')
			NotificationManager::Manager.notification('kyle', 'change2', 'work_id2', 'kylelawhorn@gmail.com')
			NotificationManager::Manager.notification('kyle', 'change3', 'work_id3', 'kylelawhorn@gmail.com')
			NotificationManager::Manager.notification('glen', 'change4', 'work_id4', 'linda')
		end
	end
end