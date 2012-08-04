Missioncontrol::Application.routes.draw do
  root :to => "homes#index"

  resources :homes
end
