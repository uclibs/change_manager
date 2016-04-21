class MakeChange
	def self.queue
		:notification
	end

	def self.perform
		puts 'change is made'
		
	end