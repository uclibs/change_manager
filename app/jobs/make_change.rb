class MakeChange
	def self.queue
		:notification
	end

	def self.perform
		puts 'change is made'
		# delay job N minutes
		# NotificationManager::Manager.notify(change_id)
	end