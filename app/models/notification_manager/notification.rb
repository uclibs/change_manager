require 'yaml'

module NotificationManager
  class Notification < ActiveRecord::Base
  	validates :change, :change_owner, :change_target, :change_context, presence: true

  	def self.new_notification(owner, change_made, context, target, cancelled = false)
  		# needs a spec
  		# create object in db
  		# return object id
  		foo = self.create({
        change_owner: owner, 
        # change this to change_type
        change: change_made, 
        change_context: context, 
        change_target: target, 
        change_cancelled: cancelled
        })
  		foo.id
  	end

    def cancel
      self.change_cancelled = true
      self.save
    end

    def cancelled?
      self.change_cancelled
    end

    def inverse?(possible_inverse_change)
      is_inverse = false
      change_types = YAML.load_file(File.join(NotificationManager::Engine.root, 'config/change_types.yaml'))
      if self.change == change_type[possible_inverse_change]['inverse']
        is_inverse = true
      end
      return inverse
    end

  end
end
