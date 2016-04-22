class MakeChange
	def self.queue
		:notification
	end

	def self.perform
		puts 'change is made'
		# NotificationManager::Manager.notify(change_id)
	end