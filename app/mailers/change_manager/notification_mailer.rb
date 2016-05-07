module ChangeManager
	class NotificationMailer < ActionMailer::Base
		
		def construct_email(changes)
			@body = prepare_body(changes)
			mail(
				to: changes.first.target,
				from: changes.first.owner,
				subject: 'Updates from Scholar@UC',
				)
		end

		def send_email(constructed_email)
			constructed_email.deliver
		end

		def prepare_body(changes)
			header = '<table><th><td>Change Owner</td><td>Change Context</td><td>Change</td><td>Time</td></th>'
			body = ''
			footer = '</table>'
			changes.each do |change|
				#may need a look up method from curate here
				body += '<tr><td>' + 
				change.owner + '</td><td>' + 
				change.context + '</td><td>' + 
				change.change_type + '</td><td>' + 
				change.created_at.to_s + '</td></tr>'
			end
			content = header + body + footer
		end
	end
end