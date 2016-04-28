# Resque tasks
require 'resque/tasks'
require 'resque/scheduler/tasks'

# Rails.application.config.eager_load_paths = [
# 	"/Users/kyle/workspace/notification_manager/spec/testapp/app/assets",
# 	"/Users/kyle/workspace/notification_manager/spec/testapp/app/mailers",
# 	"/Users/kyle/workspace/notification_manager/spec/testapp/app/models",
# 	"/Users/kyle/workspace/notification_manager/spec/testapp/app/models/concerns",
# 	"/Users/kyle/workspace/notification_manager/app/jobs"
# ]
Rails.application.initialize!

namespace :resque do
	task ":setup" => :environment
	# [:environment] do
	# 	require 'resque_scheduler'
	# 	require 'resque/scheduler'
end
