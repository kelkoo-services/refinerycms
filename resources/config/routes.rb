<<<<<<< HEAD
Refinery::Core::Engine.routes.prepend do
  match '/system/resources/*dragonfly', :to => Dragonfly[:refinery_resources]
=======
Refinery::Core::Engine.routes.draw do
  get '/system/resources/*dragonfly', :to => Dragonfly[:refinery_resources]
>>>>>>> 2-1-main

  namespace :admin, :path => Refinery::Core.backend_route do
    resources :resources, :except => :show do
      get :insert, :on => :collection
    end
  end
end
