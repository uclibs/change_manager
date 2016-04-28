# Resque tasks
require 'resque/tasks'
require 'resque/scheduler/tasks'

Rails.application.initialize!

namespace :resque do
	task ":setup" => :environment
end
