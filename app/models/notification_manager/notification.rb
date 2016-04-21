module NotificationManager
  class Notification < ActiveRecord::Base
  	def self.new_notification(args = {})
  		# needs a spec
  		# create object in db
  		# return object id
  		foo = self.create(args)
  		foo.id
  	end
  end
end
