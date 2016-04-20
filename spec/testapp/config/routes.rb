Rails.application.routes.draw do

  mount NotificationManager::Engine => "/notification_manager"
end
