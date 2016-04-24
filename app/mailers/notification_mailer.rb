module NotificationManager
	class NotificationMailer < ActionMailer::Base
		
		def construct_email(changes)
			body = prepare_body(changes)
			mail(
				to: changes.first.change_target,
				from: changes.first.change_owner,
				subject: 'Updates from Scholar@UC'
				)
		end

		def send_email(constructed_email)
			constructed_email.deliver
		end

		private
		def prepare_body(changes)
			header = 'begin table html here'
			body
			footer = 'begin table footer here'
			changes.each do |change|
				body + '<tr><td>' + '</td><td>' + '</td><td>' + '</td><td>' + '</td></tr>'
			end
			content = header + body + footer
		end
	end
end
