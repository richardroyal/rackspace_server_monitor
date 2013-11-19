RackspaceServerMonitor::Application.routes.draw do

  resources :boolean_settings


  resources :settings
  match "/check-all-servers/:secure_key" => "servers#check_all_servers", :as => :check_all_servers
  match "/check-all-servers" => "servers#check_all_servers"
  match "/available-servers" => "servers#available_servers", :as => :available_servers

  resources :servers

  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
  devise_for :users
  resources :users

end
