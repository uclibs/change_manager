# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :notification, :class => 'ChangeManager::Notification' do
  	owner "email@test.com"
  	change_type "added_as_delegate"
  	context "1"
  	target "spec@test.com"
  	cancelled false
  end
end
