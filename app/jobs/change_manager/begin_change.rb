require 'yaml'
module ChangeManager
  class ProcessChangeJob < ActiveJob::Base
    queue_as :default

    def perform(change_id)
      config ||= YAML.load_file(File.join(Rails.root, 'config/change_manager_config.yml'))
      config['manager_class'].constantize.process_change(change_id)
    end
  end
end
