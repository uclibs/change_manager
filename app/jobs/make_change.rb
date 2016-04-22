class MakeChange
	def self.queue
		:notification
	end

	def self.perform(change_id)
		puts 'change is made to ' + change_id.to_s
		NotificationManager::Manager.notify(change_id)
	end
end