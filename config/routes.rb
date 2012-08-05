Missioncontrol::Application.routes.draw do
  root :to => "homes#index"

  resources :accounts
  resources :homes
end
