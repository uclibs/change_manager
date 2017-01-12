$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "change_manager/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "change_manager"
  s.version     = ChangeManager::VERSION
  s.authors     = ["Kyle Lawhorn"]
  s.email       = ["lawhorkl@mail.uc.edu"]
  s.homepage    = "http://www.thegeekycoder.com"
  s.summary     = "An ActiveJob-based system for comparing ActiveRecord objects and sending out notifications of the changes."
  s.description = "ChangeManager uses ActiveJob and the queueing engine of your choice to detect changes in ActiveRecord objects, and then apply logic to them."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails"
  s.add_development_dependency 'byebug'
  s.add_development_dependency "sqlite3"
#testing frameworks
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'factory_girl_rails'

end
