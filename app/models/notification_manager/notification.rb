module NotificationManager
  class Notification < ActiveRecord::Base
  	validates :change, :change_owner, :change_target, :change_context, presence: true

  	def self.new_notification(owner, change_made, context, target, cancelled = false)
  		# needs a spec
  		# create object in db
  		# return object id
  		foo = self.create({change_owner: owner, 
				  		   change: change_made, 
				  		   change_context: context, 
				  		   change_target: target, 
				  		   change_cancelled: cancelled})
  		foo.id
  	end

  end
end
