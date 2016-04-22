module NotificationManager
	class Manager
		# NotificationManager::Manager.notification(args)
		def self.notification(change_owner, change_made, context, change_target)
			change_id = NotificationManager::Notification.new_notification(change_owner, change_made, context, change_target)
			queue_job(change_id, 10, 'minutes')

		end

		def self.notify
			# gather all changes with same target and owner
			# determine if cancelled (yaml)
			# if cancelled (do nothing)
			# collection/hash/array of changes -> construct_email(args)
			# send_email(construct_email(args))
		end

	    def send_email(constructed_email)
	      # send the actual email
	      constructed_email.deliver
	    end

	    def construct_email(target_email, changes)
	      #use a passed array/hash type to construct the email body for all 
	      #changes concerning a user
	      body = prepare_body(changes)
	      #mailer here
	    end
	    def prepare_body(changes)
	    	#create html needed for the table with loop
	    	#will need helper methods here to write the different changes
	    end
	# dont need this
	    def queue_job(change_id, delay = 5)
	      # start the redis worker with needed delay
	      Resque.enqueue_at(delay.minutes.from_now, MakeChange, change_id)
	    end

	    def cancel_change(change_id)

	      # cancel the change in the model
	      # notification.change_cancelled = true
	    end
	end
end