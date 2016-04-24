module NotificationManager
	class Manager
		# NotificationManager::Manager.notification(args)
		def self.notification(change_owner, change_made, context, change_target)
			change_id = Notification.new_notification(change_owner, change_made, context, change_target)
			# queue_job(change_id)
			Resque.enqueue(MakeChange, change_id)
		end

		# run populate_test_data from console
		def self.notify(change_id)
			# gather all changes with same target and owner
			change = Notification.find(change_id)
			similar_changes = group_similar_changes(change.change_owner, change.change_target, change.change_context)
			# byebug
			# collection/hash/array of changes -> construct_email(args)
			# send_email(construct_email(similar_changes))
			puts 'the notify method was called'

		end

		def self.group_similar_changes(owner, target, context = nil)
			# populate database with preset test data

			# long query where it selects all rows where change_owner and change_target are the same as original
			# also where cancelled is false
			# determine if cancelled (yaml)
			# if cancelled (do nothing)
			similar_changes = Notification.where(change_owner: owner, change_target: target, change_cancelled: false)
			similar_changes.each do |change|
				unless change.change_cancelled == false || change.change_cancelled.nil?
					similar_changes.delete(change)
				end
			end
			return similar_changes
		end

		def self.populate_test_data
			NotificationManager::Manager.notification('kyle', 'change1', 'work_id1', 'james')
			NotificationManager::Manager.notification('kyle', 'change2', 'work_id2', 'james')
			NotificationManager::Manager.notification('linda', 'change3', 'work_id3', 'james')
			NotificationManager::Manager.notification('glen', 'change4', 'work_id4', 'linda')
		end
	end
end