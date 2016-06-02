require 'yaml'
module ChangeManager
	class BeginChange
		def self.queue
			:change
		end

		def self.perform(change_id)
			puts 'job started'
			config ||= YAML.load_file(File.join(Rails.root, 'config/change_manager_config.yml'))
			config['manager_class'].constantize.process_change(change_id)
		end
	end
end