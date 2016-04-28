class MakeChange
	def self.queue
		:notification
	end

	def self.perform(change_id)
		puts 'job started'
		puts 'change is made to ' + change_id.to_s if NotificationManager::Manager.notify(change_id)
		puts 'job finished'
	end
end