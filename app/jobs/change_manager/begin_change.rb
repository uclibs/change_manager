require 'yaml'
module ChangeManager
	class BeginChange
		def self.queue
			:change
		end

		def self.perform(change_id)
			config ||= YAML.load_file(File.join(Rails.root, 'config/change_manager_config.yml'))
			config['manager_class'].constantize.process_change(change_id)
		end
	end
end
