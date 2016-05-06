require 'yaml'

module NotificationManager
  class Notification < ActiveRecord::Base
  	validates :change_type, :owner, :target, :context, presence: true

  	def self.new_notification(owner, change_type, context, target, cancelled = false)
  		# needs a spec
  		# create object in db
  		# return object id
  		foo = self.create({
        owner: owner, 
        change_type: change_type, 
        context: context, 
        target: target, 
        cancelled: cancelled
        })
  		foo.id
  	end

    def cancel
      self.cancelled = true
      self.save
    end

    def cancelled?
      self.cancelled
    end

    def inverse_of?(possible_inverse_change)
      is_inverse = false
      @change_types ||= YAML.load_file(File.join(NotificationManager::Engine.root, 'config/change_types.yaml'))
      if self.change_type == @change_types[possible_inverse_change.change_type]['inverse']
        is_inverse = true
      end
      return is_inverse
    end
  end
end
