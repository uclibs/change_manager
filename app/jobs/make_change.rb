class MakeChange
	def self.queue
		:notification
	end

	def self.perform(change_id)
		# sleep 60
		puts 'job started'
		# byebug
		unless NotificationManager::Notification.find(change_id).change_cancelled == true
			puts 'change is made to ' + change_id.to_s if NotificationManager::Manager.notify(change_id)
		end
		puts 'job finished'
	end
end