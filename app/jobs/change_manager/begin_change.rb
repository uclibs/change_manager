module ChangeManager
	class BeginChange
		def self.queue
			:change
		end

		def self.perform(change_id)
		    ChangeManager::Manager.process_change(change_id)
		end
	end
end