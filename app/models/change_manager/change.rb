require 'yaml'

module ChangeManager
  class Change < ActiveRecord::Base
  	validates :change_type, :owner, :target, presence: true

  	def self.new_change(owner, change_type, context, target, cancelled = false)
  		# needs a spec
  		# create object in db
  		# return object id
  		foo = self.create({
        owner: owner, 
        change_type: change_type, 
        context: context, 
        target: target, 
        cancelled: cancelled,
        notified: nil
        })
  		foo.id
  	end

    def cancel
      self.cancelled = true
      self.save
    end

    def notify
      self.notified = DateTime.now
      self.save
    end

    def cancelled?
      self.cancelled
    end

    def notified?
      if self.notified.nil?
        return false
      end
      true
    end

    def inverse_of?(possible_inverse_change)
      @change_types ||= YAML.load_file(File.join(ChangeManager::Engine.root, 'config/change_types.yml'))
      if self.context == possible_inverse_change.context
        self.change_type == @change_types[possible_inverse_change.change_type]['inverse']
      else 
        false
      end
    end



  end
end
