module NotificationManager
	class NotificationMailer < ActionMailer::Base
		
		def construct_email(changes)
			mail(
				to: changes.first.change_target,
				from: changes.first.change_owner,
				subject: 'Updates from Scholar@UC',
				body: prepare_body(changes)
				)
		end

		def send_email(constructed_email)
			constructed_email.deliver
		end

		private
		def self.prepare_body(changes)
			header = '<table>'
			body = ''
			footer = '</table>'
			changes.each do |change|
				#may need a look up method from curate here
				body += '<tr><td>' + 
				change.change_owner + '</td><td>' + 
				change.change_context + '</td><td>' + 
				change.change_target + '</td><td>' + 
				change.created_at.to_s + '</td></tr>'
			end
			content = header + body + footer
		end
	end
end
