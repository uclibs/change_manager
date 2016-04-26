# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :notification, :class => 'NotificationManager::Notification' do
  	change_owner "email@test.com"
  	change "added_as_delegate"
  	change_context "1"
  	change_target "spec@test.com"
  	change_cancelled false
  end
end
