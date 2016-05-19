class MakeChange
	def self.queue
		:change
	end

	def self.perform(change_id)
	    ChangeManager::Manager.notify(change_id)
	end
end