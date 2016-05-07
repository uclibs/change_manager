Rails.application.routes.draw do

  mount ChangeManager::Engine => "/change_manager"
end
